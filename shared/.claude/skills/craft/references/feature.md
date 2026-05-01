# Feature

**Trigger:** "Start feature"

## Goal
Entry point for any new work. **The only place in the entire workflow where the user is asked for a slug.** Sets up the per-feature folder, creates a git branch, and writes the slug into `STATE.md` so every downstream phase (`spec`, `quick`, `issues`, `implement`, `review`) can read it from one source of truth.

Run `/craft feature` **before** `spec` or `quick`.

## What this command does

1. Asks the user: *"Spec mode or quick mode?"*
2. Asks the user for a **slug** (kebab-case feature name).
3. Reads `.specs/project/STATE.md` (if it exists). If `Current Feature` is set to a different slug, asks the user whether to overwrite it.
4. Creates the feature folder:
   - Spec mode → `.specs/features/[slug]/`
   - Quick mode → `.specs/quick/[slug]/`
5. Creates a git branch named after the slug (`git checkout -b [slug]`).
6. Writes the slug into `.specs/project/STATE.md` under `Current Feature`. Creates STATE.md with the minimal template if it does not exist yet.

## Process

1. **Verify setup.** Confirm `.specs/project/` exists. If it doesn't, stop and tell the user to run `/craft start` first.
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

- **`/craft feature` is the ONLY place that asks the user for a slug.** Every downstream skill reads it from `STATE.md`. Never duplicate this prompt anywhere else.
- **Always check `STATE.md` for an existing `Current Feature` before overwriting.** Never silently replace an active slug.
- **This command is plumbing.** Sets up the slug, folder, branch, and STATE.md (if missing). Nothing else.
- **Never override the git author** when creating the branch. Branch creation is pure git plumbing — it does not produce commits.

## Tips

- **One slug, one branch, one folder.** If the user wants to change scope mid-flow, run `/craft feature` again to re-set the active slug.
- **Slug naming is sticky.** It becomes the branch name, the folder name, and the key downstream skills look up — pick something meaningful.
- **Quick or spec, same plumbing.** Both modes get a git branch and a slug in `STATE.md`. The only difference is which folder gets created.
