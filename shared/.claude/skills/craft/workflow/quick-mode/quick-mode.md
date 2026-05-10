# Quick Mode

**Goal:** Execute small, ad-hoc tasks with the same quality principles but without full pipeline ceremony.

**Trigger:** "Start quick mode", "Quick fix", "Quick task", "Small change"

**Prerequisite:** `/craft feature` has already been run with mode = `quick`. The slug, the folder `.specs/quick/[slug]/`, and the git branch already exist.

---

## Process

### 1 — Read the active slug from STATE.md

Read `.specs/project/STATE.md` → `Current Feature`. That is the active slug.

- If it is `none` or missing → **stop** and tell the user:
  > "No active feature found. Run `/craft feature` first."
- Print the resolved slug so the user sees what's active.

Verify `.specs/quick/[slug]/` exists. If it doesn't, stop and tell the user to run `/craft feature` (quick mode) first.

### 2. Describe the Task

User provides a clear, one-sentence description. If vague, ask for specifics:

- ❌ "Fix the login" → Ask: "What's broken? What should happen instead?"
- ✅ "Fix: login button returns 401 because token refresh skips expired check"

Once the description is clear, write `.specs/quick/[slug]/TASK.md` using the TASK.md template below. Fill in the description, leave Files Changed / Verification / Commit fields as placeholders — they get filled as later steps complete.

### 3. Pre-Implementation Check

Before writing code, state:

```
Quick Task: [description]
Files: [list ONLY files to touch]
Approach: [one sentence]
Verify: [how to prove it works]
```

Get user approval before proceeding. If the pre-implementation check reveals the task is bigger than expected (>3 files, unclear dependencies, design decisions needed), recommend the full pipeline instead.

### 4. Implement

Follow [coding-principles.md](../../references/coding-principles.md):

- Simplest code that works
- Touch ONLY listed files
- No scope creep — fix the thing, nothing else

### 5. Verify

Run verification from step 3. Mark done only after verification passes.

### 6. Commit

Atomic commit following [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/):

```
<type>(<scope>): <description>
```

Use imperative mood, lowercase, no period. See [implement.md](../implement/implement.md) for full types table.

Examples:

- `fix(auth): prevent 401 on token refresh`
- `feat(settings): add dark mode toggle`
- `chore(deps): update eslint to v9`

### 7. Track

Update `.specs/project/STATE.md` with quick task record (see state-management.md Quick Tasks section). Update the TASK.md created in step 2 with the final Files Changed, Verification result, and commit hash. Write `.specs/quick/[slug]/SUMMARY.md` from the SUMMARY.md template below — short bullets of what was done plus the commit hash.

---

## Structure

Quick tasks live separately from planned features:

```
.specs/
└── quick/
    └── [slug]/
        ├── TASK.md       # Description + verification
        └── SUMMARY.md    # What was done + commit
```

**TASK.md template:**

```markdown
# Quick Task [slug]: [Title]

**Date:** [date]
**Status:** Done | In Progress | Blocked

## Description

[One sentence: what and why]

## Files Changed

- `src/path/to/file.ts` — [what changed]
- `src/path/to/other.ts` — [what changed]

## Verification

- [ ] [How to verify it works]
- [ ] [Expected behavior after fix]

## Commit

`[hash]` — [commit message]
```

**SUMMARY.md template:**

```markdown
# What was done

[1–3 bullets describing what changed and why]

## Commit

`[hash]` — [commit message]
```

---

## Guardrails

- **Max 3 files** — If more, use full pipeline
- **Max 1 hour** — If longer, scope is wrong
- **No design decisions** — If you're choosing between approaches, use full pipeline
- **No new dependencies** — Adding packages needs full pipeline review
- **Track everything** — Even quick tasks get commits and STATE.md entries

---

## Tips

- **Quick ≠ sloppy** — Same coding principles apply, just less ceremony
- **When in doubt, go full** — Better to over-plan than to ship broken code
- **Quick tasks compound** — If you're doing 5+ quick tasks for the same area, it's a feature that needs planning
- **Verify before marking done** — The whole point is quality, even for small tasks
