Systematic root-cause analysis for bugs and unexpected behavior. Enforces structured debugging with a 3-attempt fix limit to prevent going in circles.

Inspired by [gstack](https://github.com/garrytan/gstack) (Garry Tan) `/investigate` concept.

## Input

$ARGUMENTS — bug description, error message, ticket ID, or link to failing CI/logs

## When to Suggest Investigation

Proactively suggest `/investigate` when:
- The user reports a bug or unexpected behavior
- A test or CI pipeline is failing with unclear cause
- The same fix has been attempted more than once without success
- The user says "it doesn't work" without clear next steps

## Step 1: Gather Evidence

Before touching any code, collect all available signals:

1. **Reproduce** — confirm the bug exists and is reproducible
   - Read error logs, stack traces, or screenshots provided
   - If a URL/endpoint is given, test it
   - If a test is failing, run it and capture output

2. **Scope** — determine blast radius
   - Which module/service is affected?
   - Is this a regression? Check `git log --oneline -20` in the affected module
   - When did it last work? (`git bisect` if timestamps are available)

3. **Context** — gather surrounding information
   - Read the affected file(s) fully — don't skim
   - Check recent changes: `git log --oneline --since="1 week ago" -- <affected-files>`
   - Check related tests: do they pass or fail?

Output a brief evidence summary:

```
## Evidence
- **Symptom**: <what's happening>
- **Expected**: <what should happen>
- **Affected**: <file(s), module, service>
- **Regression**: yes/no (last working commit: <hash> if known)
- **Signals**: <key clues from logs/traces>
```

## Step 2: Form Hypotheses

List up to 3 ranked hypotheses based on evidence:

```
## Hypotheses (ranked by likelihood)
1. <most likely cause> — because <evidence>
2. <second cause> — because <evidence>
3. <third cause> — because <evidence>
```

Do NOT jump to fixing. Confirm which hypothesis is correct first by reading code or adding diagnostic output.

## Step 3: Fix (max 3 attempts)

### Attempt tracking

Maintain a running counter. After each attempt, record:

```
### Attempt N/3
- **Hypothesis tested**: #N — <description>
- **Change made**: <what you changed and why>
- **Result**: PASS / FAIL
- **If FAIL, learned**: <what this rules out or reveals>
```

### Rules

- **One hypothesis per attempt** — don't shotgun multiple changes
- **Minimal change** — smallest possible fix that tests the hypothesis
- **Verify** — run the failing test or reproduce step after each attempt
- **Revert on failure** — undo the change before trying the next hypothesis (`git checkout -- <file>`)

### After 3 failed attempts: STOP

Do NOT continue guessing. Instead:

```
## Investigation Stalled (3/3 attempts exhausted)

### What we know
- <confirmed facts from attempts>

### What we ruled out
- <hypotheses disproven>

### Recommended next steps
- [ ] <specific diagnostic action, e.g., "add logging at X to capture Y">
- [ ] <escalation path, e.g., "pair with the module owner">
- [ ] <alternative approach, e.g., "check cloud logs for upstream failure">
```

Ask the user how to proceed. Options:
1. Try a different approach (reset attempt counter)
2. Escalate — use `/delegate` to dispatch to another agent, or pair with a team member
3. Shelve — document findings and move on

## Step 4: Verify & Close

After a successful fix:

1. **Run the original reproduction step** — confirm it passes
2. **Run related tests** — ensure no regressions
3. **Document** — brief summary of root cause and fix

```
## Resolution
- **Root cause**: <one-line explanation>
- **Fix**: <what was changed>
- **Attempts**: N/3
- **Regression test**: <test name if one was added, or "existing test covers it">
```

Do NOT add unnecessary refactoring, comments, or cleanup beyond the fix itself.

## Related Skills

| If you need... | Use instead |
|----------------|-------------|
| Escalate to another agent | `/delegate` (dispatch subtask to a different model) |
| Check repo health signals | `/health-check` (CI status, lint, deps may reveal root cause) |
| Scan for dead/unused code | `/dead-code` (if the bug is from orphaned code paths) |

## Rules

1. **Never skip Step 1** — evidence gathering prevents wasted attempts
2. **Never exceed 3 fix attempts** without user approval to continue
3. **Revert failed attempts** — don't leave dead-end changes in the code
4. **One change at a time** — compound changes make it impossible to know what worked
5. **Read before fixing** — understand the code, don't pattern-match from the error message
6. **No shotgun debugging** — adding try/except, null checks, or guards without understanding why is not a fix
