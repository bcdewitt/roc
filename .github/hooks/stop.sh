#!/usr/bin/env bash
# Stop hook: validate clean state before session end.
# Checks for diagnostic artifacts, debug prints, and uncommitted src/ changes
# on fix branches. Non-blocking but warns loudly.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"
BRANCH=$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

warnings=""

# Check for uncommitted changes in src/ on fix branches
if [[ "$BRANCH" == fix/* ]]; then
  uncommitted_src=$(git -C "$REPO_ROOT" diff --name-only -- src/ 2>/dev/null || true)
  staged_src=$(git -C "$REPO_ROOT" diff --cached --name-only -- src/ 2>/dev/null || true)
  if [[ -n "$uncommitted_src" || -n "$staged_src" ]]; then
    warnings="${warnings}\n⚠ Uncommitted src/ changes on ${BRANCH}. Commit or stash before ending."
  fi

  # Check if snapshot tests exist for this branch
  # Compare against upstream/main to see what's new
  new_snapshots=$(git -C "$REPO_ROOT" diff --name-only upstream/main...HEAD -- test/snapshots/eval/ 2>/dev/null || true)
  new_src=$(git -C "$REPO_ROOT" diff --name-only upstream/main...HEAD -- src/ 2>/dev/null || true)
  if [[ -n "$new_src" && -z "$new_snapshots" ]]; then
    warnings="${warnings}\n🚨 Fix branch '${BRANCH}' has src/ changes but NO snapshot tests in test/snapshots/eval/. Every fix needs tests."
  fi
fi

# Check for temp test files that shouldn't be committed
temp_files=$(git -C "$REPO_ROOT" ls-files --others --exclude-standard -- 'test/fx/test_*.roc' 2>/dev/null || true)
if [[ -n "$temp_files" ]]; then
  warnings="${warnings}\n⚠ Untracked temp test files found (don't commit these to fix branches):\n$(echo "$temp_files" | sed 's/^/  /')"
fi

# Check for debug prints in staged/uncommitted src/ changes
debug_prints=$(git -C "$REPO_ROOT" diff -- src/ 2>/dev/null | grep -n '^\+.*std.debug.print\|^\+.*@import("std").debug' 2>/dev/null || true)
if [[ -n "$debug_prints" ]]; then
  warnings="${warnings}\n⚠ Debug print statements found in uncommitted src/ changes. Remove before committing."
fi

# Build prompt for lessons learned
prompt="SESSION END — ROC COMPILER FORK"
prompt="${prompt}\nBranch: ${BRANCH}"

if [[ -n "$warnings" ]]; then
  prompt="${prompt}\n\n--- WARNINGS ---${warnings}"
fi

prompt="${prompt}\n\nBefore finishing, consider:"
prompt="${prompt}\n1. **New bugs discovered** → document in BUGFIXES.md (if on main) or note for later"
prompt="${prompt}\n2. **Debugging dead-ends** → verify .session/dead-ends.md entries are complete"
prompt="${prompt}\n3. **Workarounds found** → note in /workspaces/software-engineering/prototype/constraint-solver-roc/ROC_LESSONS.md if Roc-specific"

if [[ "$BRANCH" == fix/* ]]; then
  prompt="${prompt}\n4. **Branch status** → Is this fix complete? Does it need snapshot tests? Is it ready for verification?"
fi

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "Stop",
    "additionalContext": "$(echo -e "$prompt" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/"/\\"/g')"
  }
}
EOF
