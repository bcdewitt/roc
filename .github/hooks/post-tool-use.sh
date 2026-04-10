#!/usr/bin/env bash
# PostToolUse hook: reinforce branching discipline and debugging methodology.
# - Periodic self-check every 15 tool calls
# - After source file edits: branch check + snapshot test reminder
# - After test failures: debugging methodology reminder
set -euo pipefail

# ── Tool call counter ────────────────────────────────────────────────────────
COUNT_FILE="/tmp/.copilot-roc-tool-call-count"
COUNT=$(cat "$COUNT_FILE" 2>/dev/null || echo 0)
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNT_FILE"

# Read hook input from stdin
INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"\s*:\s*"[^"]*"' | head -1 | sed 's/.*"\([^"]*\)"/\1/' || true)

context=""

# ── Periodic self-check (every 15 tool calls) ────────────────────────────────
if (( COUNT % 15 == 0 )); then
  REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"
  BRANCH=$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

  context="SELF-CHECK (${COUNT} tool calls) | Branch: ${BRANCH}"
  context="${context}\n(1) What is your current goal — still on track?"
  context="${context}\n(2) Are you on the correct branch for this work?"
  context="${context}\n(3) If fixing a bug: are you on a fix/ branch, not main?"
  context="${context}\n(4) If you've hit 2+ test failures on the same issue, delegate to @debugger."
  context="${context}\n(5) If editing src/ files: have you planned snapshot tests?"
fi

# ── After source file edits: branch + test reminder ──────────────────────────
# Check the full input for any reference to src/ files (handles nested JSON escaping)
if echo "$INPUT" | grep -qiE '/src/|\\\\src/|src/[a-z]'; then
  REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"
  BRANCH=$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

  branch_msg=""
  if [[ "$BRANCH" == "main" ]]; then
    branch_msg="🚨 BRANCH WARNING: You are editing src/ files on 'main'. Bug fixes must go on fix/ branches. Create one: git checkout -b fix/<name> upstream/main"
  elif [[ "$BRANCH" != fix/* ]]; then
    branch_msg="⚠ BRANCH CHECK: You are on '${BRANCH}', not a fix/ branch. If this is a bug fix, it should be on a fix/<name> branch based on upstream/main."
  fi

  if [[ -n "$branch_msg" ]]; then
    test_msg="${branch_msg}\nREMINDER: Every source fix needs snapshot tests in test/snapshots/eval/. See CONTRIBUTING.md."
    if [[ -n "$context" ]]; then
      context="${context}\n${test_msg}"
    else
      context="$test_msg"
    fi
  fi
fi

# ── After test failures: debugging methodology reminder ───────────────────────
if [[ "$TOOL_NAME" == "run_in_terminal" || "$TOOL_NAME" == "runTests" ]]; then
  TOOL_RESPONSE=$(echo "$INPUT" | grep -o '"tool_response"\s*:\s*"[^"]*"' | head -1 || true)
  if echo "$TOOL_RESPONSE" | grep -qiE 'FAIL|error|panic|segfault|SIGSEGV|core dump|stack overflow|assertion|abort'; then
    debug_msg="DEBUGGING REMINDER: Before your next action —"
    debug_msg="${debug_msg}\n(1) Write your hypothesis in one sentence."
    debug_msg="${debug_msg}\n(2) Write what you'd expect if WRONG (falsification criterion)."
    debug_msg="${debug_msg}\n(3) Check .session/dead-ends.md to avoid re-testing eliminated paths."
    debug_msg="${debug_msg}\n(4) Build a behavioral map (test variants) BEFORE reading source code."
    debug_msg="${debug_msg}\nFull methodology: delegate to @debugger if 2+ failures on the same issue."
    if [[ -n "$context" ]]; then
      context="${context}\n${debug_msg}"
    else
      context="$debug_msg"
    fi
  fi
fi

# ── After git operations: branching process reminder ──────────────────────────
if [[ "$TOOL_NAME" == "run_in_terminal" ]]; then
  if echo "$INPUT" | grep -qiE 'git\s+(checkout|branch|merge|commit|push)'; then
    git_msg="BRANCHING PROCESS: Fix branches from upstream/main. Name: fix/<name>. Must include snapshot tests. See CONTRIBUTING.md."
    if [[ -n "$context" ]]; then
      context="${context}\n${git_msg}"
    else
      context="$git_msg"
    fi
  fi
fi

# Only output if we have context to inject
if [[ -n "$context" ]]; then
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "$(echo -e "$context" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/"/\\"/g')"
  }
}
EOF
else
  echo '{}'
fi
