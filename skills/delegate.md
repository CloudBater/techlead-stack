Delegate a task to one or more AI subagents in parallel.

## Input

$ARGUMENTS — task description or natural language instruction

## When to Suggest Delegation

Proactively suggest `/delegate` when the user's request involves:
- **Breadth**: multiple independent files, modules, or domains to work on
- **Depth**: research, analysis, or generation that takes sustained effort
- **Repetition**: same operation applied to N items (e.g., write tests for 10 modules)

Example triggers: "write unit tests for all services", "refactor these 5 modules", "research and document all API endpoints"

## Step 1: Understand the Task

Parse $ARGUMENTS to determine:

1. **What**: what needs to be done (code, tests, research, docs, analysis)
2. **How many**: can it be split into parallel subtasks? If yes, how many?
3. **Output type**: code changes, documentation, analysis report, or mixed?

## Step 2: Ask the User

Before dispatching, confirm with the user:

```
I can split this into N parallel subtasks:
1. <subtask description>
2. <subtask description>
...

Output destination:
  (a) Direct commit to current branch (for small, safe changes)
  (b) New feature branch (for larger changes needing review)
  (c) Files only — no git (for docs, analysis, research output)
  (d) Worktree per subtask (for isolated, independent changes)

Proceed?
```

Skip this confirmation ONLY if the user already specified these details in their request.

## Step 3: Check Agent Availability

### Available Agents

**Built-in (preferred — no CLI needed, no worktree needed):**

| Agent | Method | Best For | Limitations |
|-------|--------|----------|-------------|
| Internal subagent | `Agent` tool with `run_in_background: true` | Code changes, tests, refactoring | Shares rate limit with main agent |
| Internal subagent (worktree) | `Agent` tool with `isolation: "worktree"` | Isolated code changes | Slower setup |

**External CLI (when built-in hits rate limits or for model diversity):**

| Agent | CLI Example | Best For | Limitations |
|-------|------------|----------|-------------|
| Claude Code (2nd instance) | `claude --print --dangerously-skip-permissions` | Complex multi-file | Separate plan limits |
| Gemini CLI | `gemini --prompt` | Research, large context | Text-only — cannot write files |
| Cursor | `cursor-agent --print --trust --yolo` | Frontend, UI work | Tends to over-generate |
| GitHub Copilot | `copilot -p --autopilot --allow-all-tools` | Quick fixes | Slowest |

Fallback chain: `internal → claude → gemini → cursor → copilot`

**Agent-specific notes:**
- **Internal subagent**: Preferred for most tasks. Use `run_in_background: true` and wait for notification. NEVER poll.
- **Gemini**: Text-only output. Extract code from markdown fences manually.
- **Cursor**: Add output size constraints to prompts (e.g., "max ~500 lines").

## Step 4: Dispatch

### Option A: Internal subagents (preferred)

Use the `Agent` tool with `run_in_background: true` for each subtask. Launch all independent subtasks in a single message for maximum parallelism.

```
Agent tool call:
  description: "<short task description>"
  prompt: "<full task prompt with context>"
  run_in_background: true
  isolation: "worktree"  # only if output type is (d) worktree
```

### Option B: External CLI

For text-only output (research, analysis, docs):

```bash
gemini --prompt "<prompt>" > /tmp/output-<task-id>.txt
```

For code changes in a worktree:

```bash
git worktree add /tmp/worktree-<task-id> -b agent/<task-id>
cd /tmp/worktree-<task-id>
claude --print --dangerously-skip-permissions "<prompt>"
```

### Prompt Template

Always include context and output expectations:

```
You are working on: {task description}

Context:
- {relevant files, modules, or background}
- {constraints: max lines, format, conventions}

Steps:
1. Read {source files} for context
2. {task-specific steps}
3. {output instruction based on destination}

{If code: include commit convention}
{If docs: specify format and target file}
{If analysis: specify output structure}
```

## Step 5: Collect Results

When background tasks complete (via notification), process immediately:

### For code output:
```bash
cd <worktree> && git log --oneline -3 && git diff HEAD~1 --stat
```

### For text output from Gemini:
```bash
# Extract code from markdown fences
sed -n '/^```python/,/^```$/p' /tmp/output-<task-id>.txt | sed '1d;$d' > <target-file>
```

## Step 6: Deliver to Destination

Based on user's choice from Step 2:

**(a) Direct commit:**
```bash
git add <files>
git commit -m "<type>(scope): description

Co-Authored-By: <agent name> <noreply@example.com>"
```

**(b) New feature branch:**
```bash
git checkout -b <branch-name>
git add <files> && git commit -m "<message>"
# Don't push — ask user for merge approval
```

**(c) Files only:** Place output files in the agreed location. No git operations.

**(d) Worktree — cherry-pick to main:**
```bash
git fetch <worktree-path> <branch-name>
git cherry-pick FETCH_HEAD --no-commit
git commit -m "<message>"
```

**Important**: Cherry-pick BEFORE removing the worktree — objects may be pruned on removal.

## Step 7: Report

Summarize all subtask results:

```
| # | Subtask | Agent | Output | Status |
|---|---------|-------|--------|--------|
| 1 | <desc>  | internal | +350 lines, 2 files | Done |
| 2 | <desc>  | gemini | 1 analysis doc | Done |
| 3 | <desc>  | internal | +500 lines, 1 file | Failed — <reason> |
```

Only ask user for **merge/commit approval** if output destination involves git.

## Step 8: Cleanup

```bash
# Remove worktrees (if used)
git worktree remove <path> --force

# Verify
git worktree list && git status
```

## Rules

1. **Prefer internal subagents** (Agent tool) over external CLI — faster, no worktree overhead
2. Always use `run_in_background: true` — never shell `&`, never poll
3. Always ask user for output destination before dispatching (unless already specified)
4. Always cherry-pick submodule/worktree commits BEFORE worktree removal
5. Never push — local only, user approves merge
6. Auto-review on notification, auto-retry once on fixable errors
7. Never commit to protected branches (`develop`, `main`, `master`) directly
