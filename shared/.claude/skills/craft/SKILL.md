---
name: craft
description: Spec-driven development workflow with two ways to develop features, feature mode and quick mode. Feature Mode runs the full pipeline (Spec → Issues → Implement → Review); Spec wraps research + specify, Issues wraps plan + tasks. Quick mode just describe and implement.
Stack-agnostic. Creates atomic tasks with verification criteria, atomic git commits, requirement traceability, and persistent memory across sessions.
metadata:
  author: João Victor
  version: 2.0.0
---

<!--
  Credits to Felipe Rodrigues and the TLC team. Craft is a fork of tlc-spec-driven; most
  content below is tlc text kept as-is, with surgical craft additions (Research phase,
  sub-agent delegation, main-agent-no-code rule, slug resolution).
-->

# Craft — Spec-Driven Development

Plan and implement projects with precision. Granular tasks. Clear dependencies. Right tools. Zero ceremony.

```
┌────────┐   ┌────────┐   ┌────────────┐   ┌─────────┐
│  SPEC  │ → │ ISSUES │ → │ IMPLEMENT  │ → │ REVIEW  │
└────────┘   └────────┘   └────────────┘   └─────────┘

* Feature Mode: full pipeline, all phases required.
* Quick Mode: Describe → Implement
```

Each wrapper bundles two related sub-steps with internal checkpoints:
- **Spec** wraps Research (grilling) + Specify (PRD generation).
- **Issues** wraps Plan (architecture) + Tasks (atomic breakdown).

## Rules

Each phase reads the artifacts of the phase before it and produces the artifacts the next phase will read. The chain is what makes the workflow work.

- **Spec** — runs Research then Specify in one phase, with an internal checkpoint between them.
  - *Research*: grills the user (via `/grill-me`) to capture vision, capabilities (P1/P2/P3), scenarios (WHEN/THEN + edges), success signals, decisions, constraints, references, and out-of-scope → `research.md`.
  - *Specify*: reads `research.md` and transforms it into the formal PRD without asking the user any clarifying questions: user stories (P1/P2/P3), WHEN/THEN/SHALL acceptance criteria, edge cases, NFRs, and traceable requirement IDs. Vagueness is flagged inline for the user to catch at sign-off → `spec.md`.
- **Issues** — runs Plan then Tasks in one phase, with an internal checkpoint between them.
  - *Plan*: reads `spec.md` (and `CONCERNS.md` if the codebase has one) to decide HOW: architecture, components and interfaces, code-reuse analysis, data models, error handling → `plan.md`.
  - *Tasks*: reads `plan.md`, `spec.md`, and `TESTING.md` (coverage matrix + parallelism + gate commands) to break the work into atomic tasks (What, Where, Depends on, Reuses, Done when, Tests, Gate, Commit) with a parallel-execution plan → `tasks.md`.
- **Implement** — reads `tasks.md` and executes one task at a time via sub-agents. Each task: RED (write tests from `Done when`) → GREEN (minimum code) → gate check → atomic commit. The main agent never writes production code — it only coordinates, updates `tasks.md` status, and closes requirement IDs in `spec.md`.
- **Review** — reads `spec.md`, `plan.md`, `tasks.md`, and the implemented code. Runs the Build-level gate, validates each WHEN/THEN criterion against the code, audits code quality, and (for user-facing features) runs interactive UAT → `review.md`. Updates requirement traceability in `spec.md`.

## Project Structure
```
.specs/
├── project/
│   ├── PROJECT.md      # Vision & goals
│   └── STATE.md        # Memory: current feature, decisions, blockers, lessons, todos, deferred ideas
├── codebase/           # Brownfield docs (existing codebases)
│   ├── STACK.md
│   ├── ARCHITECTURE.md
│   ├── CONVENTIONS.md
│   ├── STRUCTURE.md
│   ├── TESTING.md      # Coverage matrix, parallelism, gate commands
│   ├── INTEGRATIONS.md
│   └── CONCERNS.md
├── features/
│   └── [slug]/
│       ├── research.md
│       ├── spec.md # Requirements with traceable IDs
│       ├── plan.md
│       ├── tasks.md # Atomic tasks with verification (only for Large/Complex)
│       └── review.md
├── quick  # Ad-hoc tasks (quick mode)
│   └── [slug]/
│       ├── TASK.md
│       └── SUMMARY.md
└── HANDOFF.md          # Session checkpoint
```

## Workflow

**Once per project — `Start project`:**

- New project → scaffold `.specs/`, write `PROJECT.md`. No codebase-map, no `TESTING.md`. `STATE.md` is created later by `Start feature`.
- Existing codebase → scaffold `.specs/`, write `PROJECT.md`, then run `codebase-map` to derive the 7 brownfield docs (including `TESTING.md`).

**Per feature — `Start feature` first, always:**

`Start feature` is the only place that asks for a slug. It asks "spec or quick mode?", asks for the slug, creates `STATE.md` (if missing) with the slug as `Current Feature`, creates the feature folder (`.specs/features/[slug]/` or `.specs/quick/[slug]/`), and creates the git branch. Every downstream phase reads the slug from `STATE.md` — no other skill ever asks for it.

**Feature Mode (after `Start feature` with mode = spec):**

Feature mode is the default workflow to create new features in this craft workflow.

- Trigger the Spec phase with `Start spec`. The slug comes from `STATE.md`.
- Each phase produces artifacts in `.specs/features/[slug]/` that the next phase reads.
- Each phase cannot be skipped — the chain is what makes the workflow work. The user confirms the final artifact at the end of each phase, then chooses whether to proceed to the next phase.
- The main agent orchestrates the workflow, but delegates implementation tasks to sub-agents to keep the main context lean and enable parallel execution. The main agent never writes production code — every task is delegated to a sub-agent.

Spec → Issues → Implement → Review

**Quick mode (after `Start feature` with mode = quick):**

Quick mode is designed for small tasks that don't require research, specification or planning. It skips straight to implementation with a description.

Describe → Pre-implementation check → Implement → Verify -> Track in STATE.md

## Context Loading Strategy

**Base load (~15k tokens):**

- PROJECT.md (if exists)
- STATE.md (persistent memory)

**On-demand load:**

- Codebase docs (when working in existing project)
- CONCERNS.md (when planning features that touch flagged areas, estimating risk, or modifying fragile components)
- TESTING.md (when creating tasks or executing — drives test type assignment and gate checks)
- research.md (when specifying)
- spec.md (when working on specific feature)
- context.md (when designing or implementing from user decisions)
- plan.md (when implementing from plan)
- tasks.md (when executing tasks)

**Never load simultaneously:**

- Multiple feature specs
- Multiple architecture docs
- Archived documents

**Target:** <40k tokens total.
**Reserve:** 160k+ tokens for work, reasoning, outputs.
**Monitoring:** display status when >40k (see [context-limits.md](helpers/context-limits.md)).

## Sub-Agent Delegation

Use sub-agents (the Task tool or equivalent) to keep the main context window lean and enable
parallel execution. The orchestrating agent plans and coordinates; sub-agents do the heavy lifting.

**When to delegate to a sub-agent:**

| Activity                          | Delegate?          | Why                                                      |
| --------------------------------- | ------------------ | -------------------------------------------------------- |
| Research (grill mode)             | Yes                | Socratic loop runs in its own context                    |
| Implementing a task               | Yes                | File reads, edits, test output consume context; only the result matters |
| Parallel `[P]` tasks              | Yes (one per task) | The only way to run tasks truly in parallel              |
| Sequential tasks with no `[P]`    | Yes                | Keeps implementation artifacts out of the main context   |
| Planning, task creation, validation reports | No     | Require the full accumulated context to be coherent        |
| Quick mode                        | No                 | Too small to justify the overhead                        |


**Context each sub-agent receives:**

- The specific task definition from tasks.md (What, Where, Depends on, Reuses, Done when, Tests, Gate)
- Relevant coding principles and conventions (coding-principles.md, CONVENTIONS.md)
- TESTING.md, if it exists (for gate check commands and test patterns)
- Any research/spec/design context the task references

The sub-agent does NOT receive: other tasks' definitions, accumulated chat history, validation reports
from other tasks, or STATE.md (unless the task explicitly references a decision/blocker).


**What sub-agents return:**

- Status: `Complete` | `Blocked` | `Partial`.
- Files changed: [list].
- Gate-check result: command, exit code, test count delta.
- SPEC_DEVIATION markers (if any), with reasons.
- Commit hash.

The orchestrating agent uses this to update `tasks.md` status, traceability in `spec.md`, and decide next steps.

## Commands

| Trigger Pattern                                                                         | Reference                                                 |
| --------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| Start project                                                                           | [start.md](references/start.md)                           |
| Start feature                                                                           | [feature.md](references/feature.md)                       |
| Start spec                                                                              | [spec.md](references/spec.md)                             |
| Start issues                                                                            | [issues.md](references/issues.md)                         |
| Start implement                                                                         | [implement.md](references/implement.md)                   |
| Start quick mode                                                                        | [quick-mode.md](references/quick-mode.md)                 |
| Record decision, log blocker, add todo                                                  | [state-management.md](helpers/state-management.md)        |
| Pause work, end session, create handoff, resume work, continue, load handoff            | [handoff.md](helpers/handoff.md)                          |
| Review, validate, UAT, walk me through it                                               | [review.md](references/review.md)                         |

---

## Skill Integrations

This skill coexists with other skills. Before specific tasks, check if complementary skills are installed and prefer them when available.

### Diagrams → mermaid-studio

When the workflow requires a diagram (architecture overviews, flows, component diagrams), check if `mermaid-studio` is installed. If yes, delegate all diagram work to it.

### Code Exploration → codenavi

When the workflow requires code exploration (codebase research during planning, file references during implementation), check if `codenavi` is installed. If yes, delegate all code exploration to it.

## Knowledge Verification Chain

When planning, tasking, implementing, or reviewing, follow this chain to verify knowledge before acting. Always start at Step 1 and only move to the next step if the current one doesn't yield a clear answer.

```
Step 1: Codebase       → check existing code, conventions, and patterns
Step 2: Project docs   → README, docs/, inline comments, .specs/codebase/
Step 3: MCP / tools    → resolve library IDs, query for current API/patterns
Step 4: Web search     → official docs, reputable sources, community patterns
Step 5: Flag uncertain → "I'm not certain about X — here's my reasoning, but verify"
```

**Rules:**

- Never skip to Step 5 if Steps 1–4 are available.
- Step 5 is ALWAYS flagged as uncertain — never presented as fact.

**NEVER assume or fabricate.** If you cannot find an answer, say "I don't know" or "I couldn't find documentation for this". Inventing APIs, patterns, or behaviors causes cascading failures across design → tasks → implementation. Uncertainty is always preferable to fabrication.

## Code Analysis

Use available tools with graceful degradation. See [code-analysis.md](helpers/code-analysis.md).
