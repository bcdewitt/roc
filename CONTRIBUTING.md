# Contributing: Bugfix Branching Process

This fork contains fixes for compiler bugs discovered while building a constraint-solver prototype in Roc. Each fix class gets its own branch for clean review and cherry-picking.

## Branch Conventions

### Naming

```
fix/<descriptive-name>
```

Examples: `fix/recursive-nominal-types`, `fix/slice-invalidation-lower`, `fix/list-subword-store`

### Base Branch

**All fix branches MUST be created from `upstream/main`**, not from `main`. This keeps each branch self-contained and independent for upstream PR submission.

```sh
git fetch upstream
git checkout -b fix/<name> upstream/main
```

`main` is our integration branch — it merges `upstream/main` + all fix branches + documentation (BUGFIXES.md).

### Branch Contents

Each fix branch must include:

1. **Source patches** — Minimal changes in `src/` that fix the bug(s). No unrelated changes, no formatting-only commits, no diagnostic artifacts.
2. **Snapshot tests** — At least one test in `test/snapshots/eval/` demonstrating the fix. Name clearly: `recursive_nominal_binary_tree.md`, not `test1.md`.
3. **Clean commits** — Each commit should be a logical unit. Squash diagnostic/WIP commits before merging.

Each fix branch must NOT include:

- Temporary test files (e.g., `test/fx/test_*.roc`)
- Debug print statements
- Changes to files outside the bug's scope
- BUGFIXES.md edits (those go on `main` after merge)

## Verification Protocol

Before merging a fix branch to `main`, verify fail-before-fix / pass-after-fix:

1. **Build unfixed compiler** from `upstream/main`:
   ```sh
   git checkout upstream/main
   zig build
   ```

2. **Run the snapshot tests** — confirm they fail or show incorrect output:
   ```sh
   zig-out/bin/snapshot test/snapshots/eval/<test_name>.md
   ```

3. **For dev backend codegen bugs**, create a standalone `.roc` app file and run via `roc run`:
   ```sh
   zig-out/bin/roc test/fx/<test_file>.roc
   ```

4. **Switch to the fix branch**, rebuild, confirm tests pass:
   ```sh
   git checkout fix/<name>
   zig build
   zig-out/bin/snapshot test/snapshots/eval/<test_name>.md
   ```

5. **Record results** in the verification table in BUGFIXES.md (on `main`, after merge).

## Merge Protocol

1. Merge fix branch to `main` (not the other way around):
   ```sh
   git checkout main
   git merge fix/<name> --no-ff -m "Merge fix/<name>: <one-line summary>"
   ```

2. Update BUGFIXES.md on `main`:
   - Add row to branch table
   - Add detailed section for the fix
   - Update verification table with fail/pass results

3. Verify prototypes still work:
   ```sh
   cd /workspaces/software-engineering/prototype/constraint-solver-roc
   # Run all test files
   for f in *Test*.roc; do /workspaces/roc/zig-out/bin/roc test "$f"; done
   ```

## Testing Reference

| Method | What it tests | Command |
|--------|--------------|---------|
| Snapshot tool | Internal evaluator pipeline (type-level + some runtime) | `zig-out/bin/snapshot test/snapshots/eval/<name>.md` |
| `zig build test` | All unit + snapshot tests | `zig build test -Dsnapshot-tests=true` |
| `roc run` | Dev backend codegen path | `zig-out/bin/roc test/fx/<file>.roc` |
| `roc test` | Dev backend test runner | `zig-out/bin/roc test <file>.roc` |

**Key distinction:** Snapshot tests use an internal evaluator/interpreter, NOT the dev backend codegen. To verify codegen bugs (like list element corruption), you must use `roc run` on a standalone `.roc` app file.

## Current Branches

See [BUGFIXES.md](BUGFIXES.md) for the complete list of branches, bugs, and verification results.

## Related Documentation

- [AGENT.md](AGENT.md) — Compiler coding conventions, testing strategies, Roc syntax
- [BUGFIXES.md](BUGFIXES.md) — Detailed documentation of each fix branch
- `.github/instructions/` — Agent-enforced workflow rules
- `.github/agents/debugger.agent.md` — Hypothesis-driven debugging agent for compiler work
