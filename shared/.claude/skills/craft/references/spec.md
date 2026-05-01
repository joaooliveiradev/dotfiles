# Craft — Spec

**Goal**: Produce `.specs/features/[slug]/research.md` and `.specs/features/[slug]/spec.md` by chaining Research and Specify behind a single phase.

## Process

### 1 — Read the active slug from STATE.md

Read `.specs/project/STATE.md` → `Current Feature`. That is the active slug.

- If it is `none` or missing → **stop** and tell the user:
  > "No active feature found. Run `/craft feature` first."
- Print the resolved slug so the user sees what's active.

The feature folder is `.specs/features/[slug]/` (created by `/craft feature`). If `research.md` or `spec.md` already exist there, the user may be iterating on an existing feature — ask whether to overwrite or push more content into them.

### 2 — Ask the user for a feature summary

Ask the user one short question:

> "Briefly describe the feature: what are you trying to build, and what problem does it solve?"

Capture the answer as a one-paragraph summary. This is the seed Research will hand to grill-me.

### 3 — Run Research

Invoke `helpers/research.md` with the resolved slug and the feature summary. It produces `.specs/features/[slug]/research.md` and returns.

### 4 — Run Specify

Invoke `helpers/specify.md` with the resolved slug. It produces `.specs/features/[slug]/spec.md` and returns.

### 5 — Sign-off

Present `spec.md` to the user, surfacing any `⚠️ VAGUE` flags the helper recorded.

- **Approved** → ask: *"Can I call Issues now? (y/n)"*.
  - `yes` → invoke `references/issues.md`.
  - anything else → stop. The user resumes later with `Start issues`.
- **Rejected** → re-run from step 3 (Research) to fill the gaps the user pointed out

## Rules

- **One checkpoint, at the end.** Research and Specify run back-to-back. The user signs off on `spec.md` only.
- **Specify never asks clarifying questions.** Vagueness is flagged inline with `⚠️ VAGUE` and surfaced at sign-off.
- **Helpers do the work.** This wrapper orchestrates only. The grill loop lives in `helpers/research.md`; the transformation logic lives in `helpers/specify.md`.
- **Both artifacts persist.** `research.md` and `spec.md` both live in `.specs/features/[slug]/`. Downstream phases will read either.

## Tips

- **Research is exploratory; Specify is mechanical.** Keep them as two distinct mental modes.
- **Vagueness is documented, never resolved.** Caught at sign-off; bounces back to Research if rejected.
- **One slug, one Spec phase.** If the user wants to change scope mid-flow, restart from step 3.
