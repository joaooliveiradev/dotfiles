# Feature

## Goal

Entry point for any new work. **The only place in the entire workflow where the user is asked for a slug.** Asks for spec/quick mode, creates the feature folder and git branch, and writes the slug into `STATE.md` as the single source of truth for every downstream phase.

## Process

1. **Verify setup.** Confirm `.specs/project/` exists. If it doesn't, stop and tell the user to run `/craft init` first.
2. **Ask: spec or quick?** Branch on the answer; remember it for the folder choice in step 6.
3. **Ask for the slug.** Require kebab-case (lowercase, hyphens). If the input violates that, ask again.
4. **Check `STATE.md → Current Feature`:**
   - If `STATE.md` does not exist yet → proceed (it will be created in step 7).
   - If `Current Feature` is missing or `none` → proceed.
   - If a different slug is already there → tell the user *"`STATE.md` currently points at `[old-slug]`. Overwrite it with `[new-slug]`? (y/n)"*. On `n`, stop without changing anything.
   - If the same slug is already there → tell the user *"`[slug]` is already the current feature. Re-create the folder/branch? (y/n)"*. On `n`, stop.
5. **Create the folder:**
   - Spec mode → `mkdir -p .specs/features/[slug]`
   - Quick mode → `mkdir -p .specs/quick/[slug]`
6. **Create the git branch.** Run `git checkout -b [slug]`. If a branch with that name already exists, ask the user whether to switch to it (`git checkout [slug]`) or pick a different slug.
7. **Write the slug into STATE.md.**
   - If `STATE.md` does not exist, create `.specs/project/STATE.md` using the minimal template below.
   - Otherwise, replace the value under `## Current Feature` with `[slug]`.
8. **Confirm and point to the next step:**
   - Spec mode → suggest `Start spec`.
   - Quick mode → suggest `Start quick mode`.

## Minimal STATE.md template

Used only when STATE.md does not exist yet. The full structure (Decisions, Blockers, Lessons, Todos, Deferred Ideas) is added lazily by [state-management.md](../helpers/state-management.md) as those events occur — start small.

```markdown
# State

## Current Feature
[slug]
```

## Rules

- **Always check `STATE.md` for an existing `Current Feature` before overwriting.** Never silently replace an active slug.
