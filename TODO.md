# TODO

Tasks for cleaning up the compiler fork and preparing bugfix contributions.

---

## Immediate: Safeguard Work

- [ ] Create a `save/all-bugfixes` branch from current working tree — `git checkout -b save/all-bugfixes && git add -A && git commit -m "wip: save all bugfixes (Bugs 1-4, 8a, 8b) + diagnostic test files" && git push origin save/all-bugfixes && git checkout main`. This protects all uncommitted work (362 lines of source changes across 10 files + 120 untracked test files) against devcontainer rebuilds or volume loss

## Git History Cleanup

- [ ] Soft reset `main` back one commit to pop off the Bug 1 fix — `git reset --soft HEAD~1`. This un-commits the Bug 1 fix but keeps all changes staged, so we can recommit properly. The current commit (`4854685de9`) squashed the Bug 1 fix (Lower.zig closure scope + MirToLir.zig + rc_insert.zig) into `main` directly; we want it on a feature branch instead
- [ ] Unshallow the clone if needed — `git fetch --unshallow origin` so we have full history for clean rebasing

## Test File Reduction

- [ ] Inventory all `test/fx/` files (committed + untracked) and decide which to keep. Currently: 10 committed test files (good reproductions), ~120 untracked diagnostic files (`bmap_q*.roc`, `bug2_variant_*.roc`, `bug3_variant_*.roc`, `diag_*.roc`, `roc_eval_test_*.roc`). Most diagnostic files were intermediate behavioral mapping steps — keep only the minimal reproductions that demonstrate each bug clearly
- [ ] Remove or archive diagnostic test files that aren't useful as regression tests. Keep: minimal reproduction per bug, files that demonstrate the fix works. Remove: intermediate diagnostic variants, behavioral mapping exploration files
- [ ] Clean up `.rules` file — remove the debugging methodology section we added (that content now lives in the `software-engineering` project's methodology docs, not in the compiler repo)

## Branch Strategy & Commit Splitting

- [ ] Decide branch strategy — Roc uses feature branches merged via PR (e.g., `roc-lang/fix-recursive-function-outer-call`). For a fork contribution, the normal pattern is: create a branch per fix (e.g., `fix/bug1-closure-scope-in-lower`, `fix/bug4-unify-nominal-cycle`), each with clean commit(s) + test(s), then open a PR from each branch. Stacking on `main` works for personal reference but PRs should come from topic branches
- [ ] Split bugfixes into separate branches with clean commits. Candidate grouping based on which source files each bug touches:
  - **Bug 4** (unify.zig) — upstream PR #8984 already merged; may not need a PR, but verify our fork includes it
  - **Bug 3h** (layout/store.zig — `layoutsStructurallyCompatible` coinductive seen set) — standalone fix
  - **Bugs 1+2** (Lower.zig closure scope rebuild + rc_insert.zig for closures with captures) — tightly coupled, likely one PR
  - **Bug 8a** (Lower.zig slice lifetime — `getIdxSpan` → `Monotype.Span` value type) — standalone fix
  - **Bug 8b** — workaround only, no compiler fix to contribute (document in bug report instead)
  - Other changes: LirCodeGen.zig, Monomorphize.zig, coordinator.zig, MirToLir.zig — determine which bugs these belong to
- [ ] For each branch: include minimal reproduction test file + snapshot, verify `zig build test` passes, verify the fix doesn't break existing tests
- [ ] Validate each fix in isolation — stash other changes, build, run the specific reproduction test, confirm it passes with the fix and fails without it

## Upstream Contribution

- [ ] Rebase fix branches onto current `upstream/main` (currently 5 commits ahead of our fork point)
- [ ] Open PRs from topic branches (or discuss on Roc Zulip `#contributing` first per their guidelines)
- [ ] Update `software-engineering/docs/project/roc-bug-reports.md` with PR links once submitted
