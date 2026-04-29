---
name: craft-handoff
description: "Pause or resume work in the craft workflow. On pause, writes .specs/HANDOFF.md with current feature, task, completed/pending/blocked state. On resume, reads HANDOFF.md + STATE.md and proposes the next action. Triggers: 'pause work', 'end session', 'create handoff', 'resume work', 'continue', 'load handoff'."
user-invocable: true
effort: small
argument-hint: "[pause | resume]"
allowed-tools: Read, Write, Edit, Bash, Glob
---

# Craft — Handoff

Session checkpointing. Two operations: **pause** (write checkpoint) and **resume** (load checkpoint).

## Mode selection

- If `$ARGUMENTS` starts with `pause`, `end`, or `create` → Pause mode.
- If `$ARGUMENTS` starts with `resume`, `continue`, or `load` → Resume mode.
- If no args, check whether `.specs/HANDOFF.md` exists: exists → default Resume, missing → default Pause.

## Rules

- Pause is cheap. Encourage frequent checkpointing.
- Resume never runs code automatically — it proposes, the user confirms.
- Handoff is session-scoped, not feature-scoped. One file at `.specs/HANDOFF.md` regardless of how many features are in flight.
- Keep it actionable, not narrative. No "I was working on...". Yes "Next: finish T3 by writing the validation function in src/x.ts:42".

---

## Pause Work

**Trigger:** "Pause work", "End session", "Create handoff"

**Purpose:** Checkpoint current state for resumption.

**Output:** `.specs/HANDOFF.md` (overwrites previous)

**Size target:** ~500 tokens

### Gather context

- Current feature from `.specs/project/STATE.md` → `Current Feature`.
- Current task from the in-progress row in `.specs/features/[slug]/tasks.md` (if a feature is active).
- Completed items since last handoff (cross-reference tasks.md status).
- Pending next steps.
- Blockers (cross-reference STATE.md `Blockers`).
- Git context: current branch, uncommitted files (`git status --short`).

### Structure

```markdown
# Handoff

**Date:** [ISO timestamp]
**Feature:** [feature name]
**Task:** [task identifier] - [brief status]

## Completed ✓

- [Completed work item]
- [Completed work item]

## In Progress

- [Current work] ([percentage or status])
- Specific location: [file:line if applicable]

## Pending

- [Next immediate step]
- [Following step]

## Blockers

- [Blocker description] - [impact]

## Context

- Branch: [git branch if applicable]
- Uncommitted: [files with changes]
- Related decisions: [STATE.md references if applicable]
```

### Instructions

- Focus on actionable information for resumption
- Include specific file/line references where relevant
- Note uncommitted changes explicitly
- Reference related STATE.md entries if applicable
- Overwrite any existing `.specs/HANDOFF.md`
- Point out the next step the user would take on resume

---

## Resume Work

**Trigger:** "Resume work", "Continue", "Load handoff"

### Process

1. Load HANDOFF.md. If missing, stop and tell the user there's nothing to resume.
2. Load STATE.md for context.
3. Summarize current position using the response pattern below.
4. Propose next action — typically `/craft-implement [slug] [task-id]` if a task is mid-flight, or whatever phase the handoff indicates.
5. Wait for the user to confirm before running anything.

### Response pattern

- "Resuming [feature] at [task]"
- "Completed: [summary]"
- "Next: [immediate action]"
- "Continue with [specific step]?"
