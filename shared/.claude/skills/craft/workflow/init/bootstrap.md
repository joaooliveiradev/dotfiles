# Bootstrap

## Goal

Generate `.craft/` content artifacts: `PROJECT.md`, `.craft/codebase/STACK.md`, optional brownfield docs (delegated to `bootstrap-brownfield.md`), and standards-pack matching.

## Process

1. **Ask: new project or existing codebase?** Branch the rest of the flow on the answer.
2. **Create folders.** `mkdir -p .craft/project .craft/features .craft/codebase`
3. **Run the PROJECT.md interview** (see below). Write `.craft/project/PROJECT.md` when done.
4. **Generate `.craft/codebase/STACK.md`** using the template below.
   - New project: derive from `PROJECT.md`'s Tech Stack section.
   - Existing codebase: extract via `codenavi` from dependency manifests.
5. **If existing codebase** → invoke `workflow/init/bootstrap-brownfield.md`.
6. **Match `STACK.md` against `~/.claude/standards/`** (see Standards matching).

## Rules

- Never overwrite an existing file in `.craft/` without explicit user confirmation.
- Never make git commits — this skill only creates files.
- Do not invent facts. If the user doesn't know, log it in Open Questions (PROJECT.md).

---

## PROJECT.md interview

Extract project vision via iterative Q&A (max 3-5 questions per message):

**Essential questions:**

1. What are you building?
2. Who is it for and what problem does it solve?
3. What tech stack are you using? (if known)
4. What's in scope for v1? What's explicitly excluded?
5. Critical constraints? (timeline, technical, resources)

**Stop when:** Clear understanding of vision, goals, and boundaries.

### Output: .craft/project/PROJECT.md

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
```

**Size limit:** 2,000 tokens (~1,200 words)

**Validation:**

- Vision clear in 1-2 sentences?
- Goals have measurable outcomes?
- Scope boundaries explicit?

---

## STACK.md

**Size limit:** 2,000 tokens (~1,200 words)

**Document:**

```markdown
# Tech Stack

**Source:** [interview | extracted]
**Analyzed:** [date]

## Core

- Framework: [name + version]
- Language: [name + version]
- Runtime: [name + version]
- Package manager: [manager]

## Frontend (if applicable)

- UI Framework: [name + version]
- Styling: [approach + tools]
- State Management: [library/pattern]
- Form Handling: [library if present]

## Backend (if applicable)

- API Style: [REST/GraphQL/gRPC + framework]
- Database: [ORM/query builder + database system]
- Authentication: [library/approach]

## Testing

- Unit: [framework]
- Integration: [framework]
- E2E: [framework if present]

## External Services

- [Category]: [Service name]
- [Category]: [Service name]

## Development Tools

- [Tool category]: [Tool name]
```

**Instructions:**

- Set `Source:` to `interview` (new project) or `extracted` (existing codebase).
- Brownfield: include versions for major dependencies from actual manifests.
- Greenfield: only include what the user stated. Empty categories are honest; do not fabricate.

---

## Standards matching

1. If `~/.claude/standards/` does not exist or is empty, skip.
2. For each named library/framework in STACK.md (Core, Frontend, Backend, Testing), compute a slug:
   - Lowercase, hyphenate words, drop punctuation
   - If a major version is stated and matters (e.g., React Router v7), suffix `-v<major>`
   - Examples: `React Router v7` → `react-router-v7`; `React` → `react`; `Tailwind CSS` → `tailwind`; `Vitest` → `vitest`
3. For each slug, check whether `~/.claude/standards/<slug>.md` exists.
4. If any matches: `mkdir -p .craft/standards` and copy each matched pack to `.craft/standards/<slug>.md`.
5. No matches → do not create `.craft/standards/`. This step never auto-generates a pack — only copies existing ones.

---

## Total Context Budget

**Combined output (greenfield):** PROJECT.md (~2k) + STACK.md (~2k) + optional standards packs = ~4-10k tokens
**Combined output (brownfield):** PROJECT.md (~2k) + STACK.md (~2k) + 6 brownfield docs (~17k via `bootstrap-brownfield.md`) + optional standards packs = ~21-30k tokens
**Loading strategy:** Each downstream phase loads only the docs it functionally needs.
