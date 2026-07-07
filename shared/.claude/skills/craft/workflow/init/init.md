# Init

## Goal

One-time setup for using craft in a project. Performs filesystem prep (state check, git check, `.gitignore`), then delegates all content generation to `bootstrap.md`.

## Process

1. **Check state.** If `.craft/` already exists, ask whether to continue (re-run bootstrap, regenerate artifacts) or abort. Never overwrite an existing `PROJECT.md`, `STACK.md`, or any `.craft/codebase/*.md` file without explicit confirmation.
2. **Confirm git repo.** If `git rev-parse --git-dir` fails, warn the user before creating a `.gitignore`.
3. **Update `.gitignore`:**
   - If no `.gitignore` exists, create one with `.craft/`.
   - If `.gitignore` already lists `.craft/` or `.craft`, do nothing.
   - Otherwise append under a `# Craft workflow` comment block.
4. **Trigger** `workflow/init/bootstrap.md` that is going to create artifacts to use in our workflow, it helps new or existent projects.
5. **Confirm and point to next step:** suggest `/craft feature` to begin the first feature.

## Rules

- Never overwrite an existing file in `.craft/` without explicit user confirmation.
- Never make git commits — this skill only creates files and edits `.gitignore`.
- If not in a git repo, ask before creating `.gitignore`.
