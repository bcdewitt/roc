#!/usr/bin/env bash
# SessionStart hook: inject branch awareness and fix-branch context at conversation start.
set -euo pipefail

# Reset tool call counter for periodic self-checks
echo "0" > /tmp/.copilot-roc-tool-call-count

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"
BRANCH=$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

# List all fix branches
fix_branches=$(git -C "$REPO_ROOT" branch --list 'fix/*' 2>/dev/null | sed 's/^[* ]*/  - /' || true)

# Check if upstream remote exists
upstream_exists=$(git -C "$REPO_ROOT" remote | grep -c '^upstream$' 2>/dev/null || echo "0")

# Check for dead-ends file
dead_ends=""
if [[ -f "$REPO_ROOT/.session/dead-ends.md" ]]; then
  de_count=$(grep -c '^\s*- \*\*' "$REPO_ROOT/.session/dead-ends.md" 2>/dev/null || echo "0")
  if [[ "$de_count" -gt 0 ]]; then
    dead_ends="Dead-ends file has ${de_count} entries — read .session/dead-ends.md before debugging."
  fi
fi

# Build context message
context="ROC COMPILER FORK | Branch: ${BRANCH}"

# Warn if on main and likely about to do development
if [[ "$BRANCH" == "main" ]]; then
  context="${context}\n⚠ You are on 'main'. If you're about to fix a bug, create a fix branch first:"
  context="${context}\n  git fetch upstream && git checkout -b fix/<name> upstream/main"
  context="${context}\nSee CONTRIBUTING.md for the full branching process."
fi

if [[ -n "$fix_branches" ]]; then
  context="${context}\nFix branches:\n${fix_branches}"
fi

if [[ "$upstream_exists" -eq 0 ]]; then
  context="${context}\n⚠ No 'upstream' remote found. Add it: git remote add upstream https://github.com/roc-lang/roc.git"
fi

if [[ -n "$dead_ends" ]]; then
  context="${context}\n${dead_ends}"
fi

context="${context}\nKey docs: AGENT.md (coding conventions), CONTRIBUTING.md (branching process), BUGFIXES.md (fix details)"
context="${context}\nWorkflow enforcement: .github/instructions/ auto-loads when editing src/ or test/snapshots/"

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "$(echo -e "$context" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/"/\\"/g')"
  }
}
EOF
