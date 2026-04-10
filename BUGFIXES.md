# Bugfixes

This fork contains fixes for three classes of compiler bugs discovered while building a [constraint-solver prototype](https://github.com/bcdewitt/software-engineering/tree/main/prototype/constraint-solver-roc) in Roc. Each fix is on a separate branch from `upstream/main` for easy review and cherry-picking.

## Branches

| Branch | Bug(s) | Files Changed | Symptom |
|--------|--------|---------------|---------|
| [`fix/recursive-nominal-types`](#1-recursive-nominal-types) | 1, 2, 3, 3h, 4 | 5 source + 4 tests | Segfault or infinite loop with recursive nominal types |
| [`fix/slice-invalidation-lower`](#2-slice-invalidation-in-lowerzig) | 8a | 1 source + 2 tests | Use-after-free in function/method call argument lowering |
| [`fix/list-subword-store`](#3-list-element-subword-store) | 9, 26, 27 | 1 source + 2 tests | Wrong results for sub-8-byte list element comparisons |

## How to test

Each branch includes snapshot tests in `test/snapshots/eval/`. The snapshot tool runs an internal evaluator/interpreter, which catches type-level and some runtime issues:

```sh
# Build the snapshot tool, then run specific snapshots
zig build snapshot
zig-out/bin/snapshot test/snapshots/eval/<test_name>.md

# Or run all snapshot tests as part of the test suite
zig build test -Dsnapshot-tests=true
```

For bugs that manifest in the **dev backend codegen path** (Bug 26/27, Bug 9, recursive Str.inspect), use `roc run` on a `.roc` app file. See `test/fx/` for examples:

```sh
zig build
zig-out/bin/roc test/fx/<your_test>.roc
```

### Verified fail-before-fix / pass-after-fix

| Bug | Unfixed (upstream/main) | Fixed (main) | Verification method |
|-----|------------------------|--------------|-------------------|
| 26/27 (list subword) | `FAIL: lists are NOT equal` | `PASS: lists are equal` | `roc run` on fx test with `List(U8) == List(U8)` |
| Recursive Str.inspect | Stack overflow (exit 134) | Segfault (exit 139) — cycle detection works but downstream codegen issue remains | `roc run` on fx test calling `Str.inspect` on recursive nominal |
| Recursive tree computation | PASS | PASS | Computation paths work; the fixes prevent layout corruption in more complex scenarios |
| Slice invalidation | Nondeterministic | PASS | Use-after-free only manifests when ArrayList reallocates; small tests may pass on both |

---

## 1. Recursive Nominal Types

**Branch:** `fix/recursive-nominal-types`

**Symptom:** Programs using recursive nominal types (e.g., `Tree := [Leaf(I64), Node(Tree, Tree)]`) crash at runtime with a segfault, infinite loop, or corrupted output. Affects both dev and LLVM backends.

**Root cause:** Five locations in the compilation pipeline did not handle recursive type cycles:

| File | Function/Area | Issue |
|------|--------------|-------|
| `src/check/unify.zig` | Nominal unification | Chases recursive type variables forever without detecting the cycle |
| `src/layout/store.zig` | Layout materialization | Missing `inside_heap_container` tracking + `raw_placeholders` for recursive types behind heap indirection |
| `src/lir/MirToLir.zig` | `registerSpecializedMonotypeLayout` | Does not unwrap `HeapCell` indirection when matching nominal types, causing layout mismatch |
| `src/mir/Lower.zig` | `lowerStrInspectNominal` | `Str.inspect` on recursive nominal types recurses forever; fix adds visited-set cycle detection |
| `src/mir/Monomorphize.zig` | `resolveStrInspectHelperProcInstsForMonotype` | Same infinite recursion for `Str.inspect` helpers during monomorphization |

**Known limitation:** The `lowerStrInspectNominal` cycle detection emits a `"<recursive>"` placeholder string, which prevents the infinite loop. However, `Str.inspect` on recursive nominal types still segfaults in the dev backend due to a separate downstream codegen issue. Recursive **computation** (e.g., traversal, counting) works correctly; only `Str.inspect`/`dbg` on these types remains broken.

**Tests:**

| File | What it tests |
|------|--------------|
| `recursive_nominal_binary_tree.md` | Multi-payload recursive tag (binary tree traversal) |
| `recursive_nominal_list_str_return.md` | Recursive opaque wrapping `List(Str)` return |
| `recursive_nominal_many_functions.md` | Multiple functions operating on the same recursive type |
| `recursive_nominal_multi_param.md` | Recursive type with multiple type parameters |

---

## 2. Slice Invalidation in Lower.zig

**Branch:** `fix/slice-invalidation-lower`

**Symptom:** Nondeterministic crashes or incorrect argument types when calling functions with multiple arguments, or when using method-call syntax (dot-access) with multiple explicit arguments.

**Root cause:** Two functions in `src/mir/Lower.zig` store a direct slice into `monotype_store.extra_idx.items` to iterate over expected argument types. The loop body calls `lowerExpr` to lower each argument, which may add new monotypes to the store, triggering the backing `ArrayList` to reallocate. The slice now points to freed memory.

| Function | Line | Context |
|----------|------|---------|
| `lowerCallWithLoweredFunc` | ~6017 | Regular function calls |
| `lowerDotAccess` | ~6970 | Method/dot-access dispatch |

**Fix:** Store the `Span` descriptor (a value type: start index + length) instead of a borrowed slice. Use `getIdxSpanItem()` per-iteration to read from the (possibly-relocated) backing array.

**Note:** This is a classic use-after-free. Symptoms are nondeterministic — they depend on whether the ArrayList reallocates during argument lowering. Small programs may appear to work; the bug manifests with sufficient argument count or when other compilation activity grows the monotype store.

**Tests:**

| File | What it tests |
|------|--------------|
| `slice_invalidation_multi_arg_call.md` | 4-argument higher-order function with lambda arguments |
| `slice_invalidation_dot_access.md` | `List.walk` with 2 explicit arguments (initial state + step function) |

---

## 3. List Element Subword Store

**Branch:** `fix/list-subword-store`

**Symptom:** `List(U8)` equality comparison returns wrong results (e.g., `[1,2,3] == [1,2,3]` evaluates to `Bool.false`). Also affects large tag union equality when variants are compared as sub-8-byte values.

**Root cause:** In `src/backend/dev/LirCodeGen.zig`, the `list_get_unsafe` implementation stores elements to the stack using `emitSizedStoreMem` with the element's `ValueSize`. For sub-8-byte types (U8, U16, I32, etc.), this writes only `elem_size` bytes, leaving the upper bytes of the 8-byte-aligned stack slot uninitialized. Downstream operations that load the full qword (e.g., equality comparisons) read garbage in the upper bytes.

**Fix:** Replace `emitSizedStoreMem(frame_ptr, elem_slot, temp_reg, vs)` with `emitStoreStack(.w64, elem_slot, temp_reg)`. The preceding `emitSizedLoadMem` already zero-extends into the 64-bit register, so all upper bytes are clean. The stack slot is 8-byte aligned, so the full write is safe.

**Tests:**

| File | What it tests |
|------|--------------|
| `list_u8_equality.md` | `List(U8)` equality and inequality |
| `large_tag_union_equality.md` | 64-variant tag union with custom `is_eq` comparing via U8 conversion |

---

## Origin

All bugs were discovered while developing a constraint-solver prototype in Roc. Root causes were identified through behavioral mapping (writing diagnostic test variants to isolate structural triggers) and bisection. Detailed analysis of all 44 bugs encountered during development is available in the [parent project's bug report](https://github.com/bcdewitt/software-engineering/blob/main/docs/project/roc-bug-reports.md).
