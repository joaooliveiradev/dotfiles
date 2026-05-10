# Craft — Tasks

**Goal**: Produce `.specs/features/[slug]/plan.md` and `.specs/features/[slug]/tasks.md` by chaining Plan and Tasks behind a single phase.

## Process

### 1 — Read the active slug from STATE.md

Read `.specs/project/STATE.md` → `Current Feature`. That is the active slug.

- If it is `none` or missing → **stop** and tell the user:
  > "No active feature found. Run `/craft feature` first."
- Print the resolved slug so the user sees what's active.

Open the feature folder at `.specs/features/[slug]/`. `spec.md` must exist there — if not, stop and tell the user to run `Start spec` first. If `plan.md` or `tasks.md` already exist, the user may be iterating — ask whether to overwrite or push more content into them.

### 2 — Run Plan

Run `workflow/tasks/create-plan.md` with the resolved slug. It produces `.specs/features/[slug]/plan.md` and returns.

### 3 — Run Tasks

Run `workflow/tasks/create-tasks.md` with the resolved slug. It produces `.specs/features/[slug]/tasks.md` and returns.

### 4 — Sign-off

Present `tasks.md` to the user along with the three validation tables, then ask:

> *"Approve tasks.md and proceed to Implement? (y/n)"*

- `yes` → call `workflow/implement/implement.md`.
- `no` → stop. If the user gives feedback, restructure the failing artifacts (or bounce back to Spec if requirements themselves are wrong). Otherwise the tasks stand and the user resumes later with `Start implement`.

## Rules

- **One checkpoint, at the end.** Plan and Tasks run back-to-back. The user signs off on `tasks.md` only.
- **Spec is the contract.** Plan and Tasks both read `spec.md` as the source of truth. If something is missing or vague there, bounce to Spec — don't patch inside this phase.
- **Helpers do the work.** This wrapper orchestrates only. Architecture analysis lives in `workflow/tasks/create-plan.md`; task decomposition and validation gates live in `workflow/tasks/create-tasks.md`.
- **Both artifacts persist.** `plan.md` and `tasks.md` both live in `.specs/features/[slug]/`. Implement and Review may read either.

## Tips

- **Plan is design; Tasks is decomposition.** Keep them as two distinct mental modes.
- **Reuse is king.** Every component in the plan should reference existing patterns, and every task's `Reuses` field should point at concrete code.
- **Co-located tests, never deferred.** If a task creates a code layer that requires tests, the tests live inside that task's `Done when`.
- **One slug, one Tasks phase.** If the user wants to change scope mid-flow, restart from step 2 (or bounce to Spec).
