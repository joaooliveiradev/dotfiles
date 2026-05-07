# Code Analysis

`codenavi` is the single tool for code analysis in the craft workflow. It is always available — do not fall back to ad-hoc shell tools.

## When to Use

Delegate to `codenavi` for any of:

- Locating function / class / component definitions
- Tracing usage patterns and call sites across the codebase
- Mapping import / dependency relationships
- Refactoring impact analysis (what breaks if I change X?)
- Navigating an unfamiliar codebase area before planning or implementing
- Surfacing patterns to reuse during the Plan phase
- Finding existing code referenced by a task's `Reuses` field during Implement

## How to Invoke

Invoke `codenavi` directly. Do not wrap it in custom shell pipelines. Pass the question or pattern as `codenavi` expects, and let it drive the search.

## What Not to Do

- Don't run `grep -r` / `find` / `ripgrep` for exploration when codenavi answers the same question.
- Don't write throwaway scripts to traverse the codebase. Delegate.
- Don't bypass codenavi to "save a step" — the consistency is the point. Each phase that loads code context loads it through the same tool, so plan, tasks, and implement see the same shape of the codebase.

## Output Handling

`codenavi` returns structured findings. When you reference its output in `plan.md` or task definitions, copy concrete file paths and symbol names verbatim — do not paraphrase locations.
