# Craft Workflow — Improvements

Notes from a grilling session. Captures problems with the current craft workflow and proposed fixes. Source for the next revision.

---

## TL;DR

Current craft is calibrated for high-stakes, multi-stakeholder, regulated-quality work. For daily solo coding with Claude as the implementer, it's overweight. The artifact chain is sound; the ceremony around it is too heavy.

**Proposed shape:** `Research → PRD → Tasks → Implement → Review` (5 phases, 1 explicit gate, 4 artifacts).

---

## Problems with the current workflow

### 1. Over-decomposition (6 phases)

Research and Specify are both "what to build." Plan and Tasks are both "how to build." The split double-gates the same thinking — the user approves twice for what is essentially one decision per concept.

- **Cost:** ceremony tax in the happy case (most cases)
- **Fix:** collapse to 5 phases. Merge Plan into Tasks (one document with architecture + atomic task breakdown). Keep Research and PRD separate but allow Research to draft a tentative PRD inline when the conversation is clear enough.

### 2. Trigger-per-phase friction

6 explicit user invocations per feature (`Start research`, `Start specify`, `Start plan`, `Start tasks`, `Start implement`, `Start review`). Even in the happy case, the user is rubber-stamping 5 transitions.

- **Cost:** every feature pays the friction
- **Fix:** one explicit gate after PRD ("did I get the *what* right?"). After PRD approval, Tasks → Implement → Review runs to completion unless blocked. The user can interrupt anywhere with normal conversation.

### 3. Validation table overload

4 tables before Tasks can approve: Granularity, Diagram-Definition Cross-Check, Test Co-location, Requirement Coverage.

- **Cost:** noise; user fatigue when reviewing
- **Fix:** keep Granularity + Coverage. Drop Diagram-Definition (the diagram is visual aid, not load-bearing — task `Depends on` fields are the source of truth). Drop Test Co-location as a separate table — it's already enforced by per-task `Tests` field reading TESTING.md.

### 4. Requirement IDs / traceability matrix

`[FEAT]-NN.MM` IDs and a traceability table (Pending → In Plan → In Tasks → Implementing → Verified). Aerospace-grade for solo + Claude work.

- **Cost:** maintenance overhead, no consumer reads it
- **Fix:** drop the matrix. Keep acceptance criteria as plain bullets. Re-introduce traceability only when multi-stakeholder sign-off matters.

### 5. Main-agent-no-code rule

Forces sub-agent dispatch even for trivial edits — typo fixes, single-line bug fixes, config tweaks all go through a sub-agent.

- **Cost:** latency + token overhead for tasks that don't need context isolation
- **Fix:** sub-agent dispatch is mandatory only for tasks marked `[P]` (parallel) or "large" (>2 files / non-trivial logic). For trivial tasks, the main agent writes the code inline. The discipline of "main agent doesn't drift" comes from the task definition, not from forced delegation.

### 6. Strict RED-then-GREEN TDD order

Implement phase forces tests-first, then impl, then verify tests went RED→GREEN. The order check is a human-TDD forcing function — humans write impl first then back-fill tests, AI doesn't.

- **Cost:** ceremony without signal for AI implementers; slows simple tasks
- **Fix:** **tests mandatory, order flexible, weakening forbidden.** Tests required per the coverage matrix. Whether they're written first, alongside, or just before commit doesn't matter — what matters is they exist, they cover the "Done when" criteria, and they can't be deleted/weakened/skipped to make impl pass.

### 7. Brownfield 7 docs upfront

Before any feature can start in an existing codebase, the workflow expects STACK + ARCHITECTURE + CONVENTIONS + STRUCTURE + TESTING + INTEGRATIONS + CONCERNS.

- **Cost:** days of upfront investment; high adoption barrier
- **Fix:** lazy / on-demand. Generate STACK + STRUCTURE first (cheap, mostly automated discovery). Generate ARCHITECTURE / CONVENTIONS / INTEGRATIONS / CONCERNS only when a feature actually touches that area. TESTING is mandatory before the first feature (drives test-type assignment).

---

## Proposed workflow

```
Research → PRD → Tasks → Implement → Review
```

**5 phases, 1 explicit gate (after PRD), 4 artifacts.**

### Phase responsibilities

| Phase | Reads | Produces | User trigger |
|-------|-------|----------|--------------|
| Research | (conversation) | `research.md` (+ optional draft PRD) | `Start feature [slug]` |
| PRD | `research.md` | `spec.md` | auto-runs after Research; **explicit gate here** |
| Tasks | `spec.md`, `TESTING.md` | `tasks.md` (architecture + atomic tasks merged) | auto-runs after PRD approval |
| Implement | `tasks.md` | code + commits | auto-runs after Tasks |
| Review | all of the above + code | `review.md` | auto-runs after Implement; UAT optional |

### Single gate model

The user approves once, after PRD. That's the "did we agree on what to build?" checkpoint. Everything after that is execution — interruptible but not gated.

Rationale: PRD is the only artifact where wrong-direction matters. A bad architecture in `tasks.md` shows up immediately in Implement and gets fixed in code. A bad PRD propagates silently and costs days.

### TDD recommendation

- **Keep:** tests mandatory per coverage matrix; tests co-located with impl (same task, same commit); hard constraint against weakening/deleting tests; gate check before commit
- **Drop:** strict RED-then-GREEN order; "tests must fail first" verification step
- **Trivial tasks** (renames, config, one-liners with `Tests: none` in coverage matrix): no tests required, gate check at build level only
- **Non-trivial tasks** (new logic, behavior changes): tests-first is recommended but not enforced

### Validation tables (Tasks phase)

- **Keep:** Granularity Check, Requirement Coverage
- **Drop:** Diagram-Definition Cross-Check, Test Co-location Validation

### Sub-agent delegation (Implement phase)

- **Mandatory sub-agent:** tasks marked `[P]` (parallel execution requires isolated contexts), large tasks (>2 files or non-trivial logic)
- **Inline (main agent):** trivial tasks (renames, config, one-liners), edits to a single file under 30 lines

---

## What stays unchanged

These parts of craft are working and should not be touched:

- Artifact chain principle (each phase reads the previous artifact's output) — prevents drift, the core value prop
- Atomic commit per task — clean history, bisect-friendly
- Knowledge verification chain (codebase → docs → MCP → web → flag uncertain) — solid discipline
- STATE.md persistent memory across sessions
- TESTING.md as project-level test policy driving per-task test-type assignment
- Code reuse analysis in the planning phase
- Skill integrations (mermaid-studio, codenavi)

---

## Migration notes

When implementing this revision:

1. Merge `references/plan.md` content into `references/tasks.md` (architecture section + atomic tasks section in one doc)
2. Update `references/research.md` to allow optional PRD draft inline
3. Strip the strict RED order from `references/implement.md`; keep the test-mandatory + no-weakening rules
4. Remove Diagram-Definition Cross-Check and Test Co-location Validation tables from `references/tasks.md`
5. Remove requirement-ID traceability matrix from `references/specify.md` (rename to `prd.md` or fold into tasks)
6. Update `SKILL.md` phase diagram from 6 boxes to 5
7. Update brownfield-mapping.md to mark ARCHITECTURE/CONVENTIONS/INTEGRATIONS/CONCERNS as on-demand
8. Update sub-agent delegation table in `SKILL.md` to reflect "mandatory only for [P] or large"
