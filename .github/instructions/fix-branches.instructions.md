---
description: >
  Fix branch workflow enforcement. Auto-loads when editing compiler source files.
  Prevents common mistakes: committing to main, missing snapshot tests, dirty branches.
applyTo: "src/**"
---

# Fix Branch Workflow

When working on bug fixes in this compiler fork, follow the branching process in [CONTRIBUTING.md](../../CONTRIBUTING.md).

## Quick Reference

1. **Never commit fixes directly to `main`.** Create `fix/<name>` from `upstream/main`.
2. **Every fix needs snapshot tests** in `test/snapshots/eval/`. No exceptions.
3. **No diagnostic artifacts in fix branches** — no temp test files, no debug prints, no `test/fx/` files.
4. **Verify fail-before-fix / pass-after-fix** before merging. Record in BUGFIXES.md.

## Before Starting a Fix

```sh
git fetch upstream
git checkout -b fix/<descriptive-name> upstream/main
```

Check which branch you're on. If you're on `main` and about to edit `src/` files, STOP — switch to a fix branch first.

## Before Committing

- [ ] Am I on a `fix/` branch (not `main`)?
- [ ] Are my changes limited to the bug's scope?
- [ ] Did I add snapshot tests in `test/snapshots/eval/`?
- [ ] Are there any debug prints or temp files to remove?

## Before Merging to Main

- [ ] Verified fail on `upstream/main`, pass on fix branch?
- [ ] Clean commit history (squash WIP commits)?
- [ ] BUGFIXES.md updated (on `main`, after merge)?
- [ ] Prototype tests still pass?

## Common Mistakes

- **Editing `src/` while on `main`** — This is the #1 mistake. Always `git branch` before editing.
- **Forgetting snapshot tests** — The fix isn't done without a test that demonstrates it works.
- **Leaving temp `test/fx/` files** — These are for local verification only; don't commit to fix branches.
- **Mixing unrelated changes** — Each fix branch addresses one class of bugs. Don't bundle fixes.
