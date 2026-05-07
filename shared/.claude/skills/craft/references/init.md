# Init

## Goal

One-time setup for using craft in a project. Scaffolds the `.specs/` tree, ensures it's gitignored, interviews the user to produce `PROJECT.md`, and — for existing codebases — runs `codebase-map` to derive the brownfield docs (including `TESTING.md`).

## Process

1. **Check state.** If `.specs/` already exists, ask whether to continue (regenerate PROJECT.md, re-run codebase-map) or abort. Never overwrite an existing `PROJECT.md` or any `.specs/codebase/*.md` file without explicit confirmation.
2. **Confirm git repo.** If `git rev-parse --git-dir` fails, warn the user before creating a `.gitignore`.
3. **Ask: new project or existing codebase?** Branch on the answer.
4. **Create folders:**
   - New project → `mkdir -p .specs/project .specs/features`
   - Existing codebase → `mkdir -p .specs/project .specs/features .specs/codebase`
5. **Update `.gitignore`:**
   - If no `.gitignore` exists, create one with `.specs/`.
   - If `.gitignore` exists and already lists `.specs/` or `.specs`, do nothing.
   - Otherwise append under a `# Craft workflow` comment block.
6. **Run the PROJECT.md interview** (see below). Write `.specs/project/PROJECT.md` when done.
7. **If existing codebase → invoke `helpers/codebase-map.md`.** That helper produces all 7 brownfield docs.
8. **Confirm and point to next step:** suggest `/craft feature` to begin the first feature.

## Rules

- Never overwrite an existing file in `.specs/` without explicit user confirmation.
- Never make git commits — this skill only creates files and edits `.gitignore`.
- If not in a git repo, ask before creating `.gitignore`.
- Keep the PROJECT.md interview conversational; no more than 5 questions per turn, use the essential question below to see what to ask.
- Do not invent facts. If the user doesn't know, put it in Open Questions (PROJECT.md).

Extract project vision via iterative Q&A (max 3-5 questions per message):

**Essential questions:**

1. What are you building?
2. Who is it for and what problem does it solve?
3. What tech stack are you using? (if known)
4. What's in scope for v1? What's explicitly excluded?
5. Critical constraints? (timeline, technical, resources)

**Stop when:** Clear understanding of vision, goals, and boundaries.

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
```
