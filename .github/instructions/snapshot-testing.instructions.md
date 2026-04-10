---
description: >
  Snapshot test conventions. Auto-loads when working with snapshot test files.
  Covers structure, naming, running, and debugging with snapshots.
applyTo: "test/snapshots/**"
---

# Snapshot Testing Conventions

Snapshot tests validate compiler behavior across multiple pipeline stages. Each `.md` file in `test/snapshots/eval/` exercises: SOURCE → TOKENS → PARSE → CANONICALIZE → TYPES → PROBLEMS.

## Creating Snapshot Tests for Bug Fixes

Every fix branch requires at least one snapshot test demonstrating the fix.

### Naming

Use descriptive snake_case names that indicate what's being tested:
- `recursive_nominal_binary_tree.md` — binary tree traversal on recursive nominal types
- `slice_invalidation_multi_arg_call.md` — multi-argument function call with slice invalidation
- `list_u8_equality.md` — U8 list equality comparison

**Bad names:** `test1.md`, `bugfix.md`, `new_test.md`

### Structure

```markdown
# META
description=<what this test validates>
type=<file|expr|statement|header|repl>

# SOURCE
~~~roc
<minimal Roc code that demonstrates the fix>
~~~

# EXPECTED
<expected output — NIL, error name, or specific value>
```

### Generation

1. Write the META and SOURCE sections manually
2. Run `zig build snapshot -- test/snapshots/eval/<your_test>.md` to generate TOKENS/PARSE/CANONICALIZE/TYPES/PROBLEMS
3. Review the generated sections — ensure changes are intentional
4. Run `zig build update-expected -- test/snapshots/eval/<your_test>.md` to populate EXPECTED from PROBLEMS if needed

### Best Practices (from AGENT.md)

1. **Focused intent** — Test one specific behavior per snapshot
2. **Minimal complexity** — Simplest possible code to demonstrate the behavior. Use `...` for unimplemented parts
3. **Pipeline debugging** — Compare SOURCE → TOKENS → PARSE → CANONICALIZE → TYPES to find which stage introduces corruption

### Snapshot Tests vs. Dev Backend Tests

| Approach | Tests | Use when |
|----------|-------|----------|
| Snapshot (`zig-out/bin/snapshot`) | Internal evaluator pipeline | Type-level bugs, canonicalization bugs, parse bugs |
| `roc run` on `.roc` app file | Dev backend codegen | Runtime codegen bugs (list corruption, register allocation, etc.) |

If your bug manifests in the dev backend codegen path (e.g., wrong runtime values), snapshot tests alone won't catch it. You'll also need a `roc run` verification — see CONTRIBUTING.md § Verification Protocol.

### Roc Syntax Reference (for test SOURCE)

- `snake_case` identifiers (not camelCase)
- `and` / `or` (not `&&` / `||`)
- Lambda: `|arg1, arg2| expr`
- If: `if condition then_branch else else_branch` (no `then` keyword)
- Blocks: `{ x = 1; y = x + 2; y }`
