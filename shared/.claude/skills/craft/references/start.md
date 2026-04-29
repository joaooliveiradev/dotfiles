# Project start

**Trigger:** "Start project", "Init project", "Start new project"

## Purpose
Create the foundational structure for using the craft workflow. This includes setting up the `.specs/` directory, ensuring it's ignored by git and scaffolding the initial project documentation (PROJECT.md, STATE.MD)

## What this command does

1. Creates `.specs/`, `.specs/project/`, `.specs/features/`, `.specs/codebase/`.
2. Ensures `.specs/` is listed in the project's `.gitignore`.
3. Scaffolds `.specs/project/STATE.md` (minimal — only `Current Feature` is actively used in v1).
4. Interviews the user to produce `.specs/project/PROJECT.md`.
5. Interviews the user to produce `.specs/codebase/TESTING.md`.

## Orchestration

1. **Check state.** If `.specs/` already exists, ask whether to continue (e.g., regenerate PROJECT.md or TESTING.md) or abort. Never overwrite an existing PROJECT.md, STATE.md, or TESTING.md without explicit confirmation.
2. **Confirm git repo.** If `git rev-parse --git-dir` fails, warn the user before creating a `.gitignore`.
3. **Create folders**: `mkdir -p .specs/project .specs/features .specs/codebase`.
4. **Update `.gitignore`**:
   - If no `.gitignore` exists, create one with `.specs/`.
   - If `.gitignore` exists and already lists `.specs/` or `.specs`, do nothing.
   - Otherwise append under a `# Craft workflow` comment block.
5. **Scaffold STATE.md** at `.specs/project/STATE.md` using the STATE template below. Do not populate anything beyond headings; the file is structural scaffolding. `Current Feature` starts as `none`.
6. **Run the PROJECT.md interview** (see below). Write `.specs/project/PROJECT.md` when done.
7. **Run the TESTING.md interview** (see below). Write `.specs/codebase/TESTING.md` when done.
8. **Confirm and point to next step**: suggest `/craft-research <feature-slug>` to begin the first feature.

## Rules

- Never overwrite an existing file in `.specs/` without explicit user confirmation.
- Never make git commits — this skill only creates files and edits `.gitignore`.
- If not in a git repo, ask before creating `.gitignore`.
- Keep interviews conversational; no more than 5 questions per turn.
- Do not invent facts. If the user doesn't know, put it in Open Questions (PROJECT.md) or leave a TODO marker (TESTING.md).



```markdown
# STATE

Cross-session memory for this project. Updated by craft skills as work progresses.

## Current Feature
none

## Decisions

## Blockers

## Lessons

## Todos

## Deferred Ideas
```

Only `Current Feature` is actively read/written in v1 (by `/craft-research` and subsequent feature-level skills). Other sections are structural placeholders for future skills; leave them empty.

## Output: .specs/project/PROJECT.md

**Structure:**

```markdown
# [Project Name]

**Vision:** [1–2 sentence description]
**For:** [target users]
**Solves:** [core problem being addressed]

## Goals

- [Primary goal with measurable success metric]
- [Secondary goal with measurable success metric]

## Tech Stack

**Core:**

- Framework: [name + version]
- Language: [name + version]
- Database: [name]

**Key dependencies:** [3–5 critical libraries/frameworks]

## Scope

**v1 includes:**

- [Core capability 1]
- [Core capability 2]
- [Core capability 3]

**Explicitly out of scope:**

- [What is NOT being built]
- [What is NOT being built]

## Constraints

- Timeline: [if applicable]
- Technical: [if applicable]
- Resources: [if applicable]

**Size limit:** 2,000 tokens (~1,200 words)

**Validation:**

- Vision clear in 1-2 sentences?
- Goals have measurable outcomes?
- Scope boundaries explicit?
