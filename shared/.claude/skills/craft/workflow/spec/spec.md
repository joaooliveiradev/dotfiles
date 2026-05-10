# Craft — Spec

## Goal

Grill the user about the feature, then write `.specs/features/[slug]/spec.md` — a testable PRD with traceable IDs.

## Process

1. **Resolve the slug.** Read `.specs/project/STATE.md` → `Current Feature`. If `none` or missing → stop and tell the user to run `/craft feature` first. Print the resolved slug.
2. **Ask for a feature description.** One short question: *"Briefly describe the feature: what are you trying to build, and what problem does it solve?"*
3. **Run grill-me.** Invoke the `grill-me` skill with the user's description as context. Don't pass the slug. Don't prescribe stop conditions — grill-me decides when it's done. The full Q&A stays in this conversation.
4. **Write spec.md.** Write `.specs/features/[slug]/spec.md` using the template below, filled entirely from the grilling conversation. Don't ask the user any clarifying questions while writing — flag gaps inline with `⚠️ VAGUE: [what's unclear]` and surface every flag at the top of the file.
5. **Sign-off.** Present `spec.md`, surfacing the `⚠️ VAGUE` flags.
   - **Approved** → ask: *"Can I call Tasks now? (y/n)"*. `yes` → invoke `workflow/tasks/tasks.md`. Anything else → stop.
   - **Rejected** → re-run from step 3 to fill the gaps.


## Template: `.specs/features/[slug]/spec.md`

```markdown
# [Feature Name] Specification

## Problem Statement

[Describe the problem in 2-3 sentences. What pain point are we solving? Why now?]

## Goals

- [ ] [Primary goal with measurable outcome]
- [ ] [Secondary goal with measurable outcome]

## Out of Scope

Explicitly excluded. Documented to prevent scope creep.

| Feature     | Reason         |
| ----------- | -------------- |
| [Feature X] | [Why excluded] |
| [Feature Y] | [Why excluded] |

---

## User Stories

### P1: [Story Title] ⭐ MVP

**User Story**: As a [role], I want [capability] so that [benefit].

**Why P1**: [Why this is critical for MVP]

**Acceptance Criteria**:

- [FEAT-01.1] WHEN [user action/event] THEN system SHALL [expected behavior]
- [FEAT-01.2] WHEN [user action/event] THEN system SHALL [expected behavior]
- [FEAT-01.3] WHEN [edge case] THEN system SHALL [graceful handling]

**Independent Test**: [How to verify this story works alone — e.g., "Can demo by doing X and seeing Y"]

---

### P2: [Story Title]

**User Story**: As a [role], I want [capability] so that [benefit].

**Why P2**: [Why this isn't MVP but important]

**Acceptance Criteria**:

- [FEAT-02.1] WHEN [event] THEN system SHALL [behavior]
- [FEAT-02.2] WHEN [event] THEN system SHALL [behavior]

**Independent Test**: [How to verify]

---

### P3: [Story Title]

**User Story**: As a [role], I want [capability] so that [benefit].

**Why P3**: [Why this is nice-to-have]

**Acceptance Criteria**:

- [FEAT-03.1] WHEN [event] THEN system SHALL [behavior]

---

## Edge Cases

- WHEN [boundary condition] THEN system SHALL [behavior]
- WHEN [error scenario] THEN system SHALL [graceful handling]
- WHEN [unexpected input] THEN system SHALL [validation response]

---

## Non-Functional Requirements

Constraints and quality bars carried over from grilling. Plan must respect these.

- [Constraint — e.g., "P95 latency < 200ms for /search"]
- [Constraint — e.g., "Must support offline mode on mobile"]
- [Constraint — e.g., "WCAG 2.1 AA accessibility"]

---

## Requirement Traceability

Each acceptance clause gets a unique ID for tracking across plan, tasks, and validation. One row per WHEN/THEN clause — not per story — so tasks can claim individual clauses and orphans become detectable.


| Clause ID   | Story       | Clause                       | Status  |
| ----------- | ----------- | ---------------------------- | ------- |
| [FEAT]-01.1 | P1: [Story] | WHEN [event] THEN [behavior] | Pending |
| [FEAT]-01.2 | P1: [Story] | WHEN [event] THEN [behavior] | Pending |
| [FEAT]-01.3 | P1: [Story] | WHEN [edge] THEN [handling]  | Pending |
| [FEAT]-02.1 | P2: [Story] | WHEN [event] THEN [behavior] | Pending |

**ID format:** `[CATEGORY]-[STORY].[CLAUSE]` (e.g., `AUTH-01.1`).

**Status values:** Pending → In Plan → In Tasks → Implementing → Verified

**Coverage:** X total, Y mapped to tasks, Z unmapped ⚠️

---

## Success Criteria

How we know the feature is successful:

- [ ] [Measurable outcome — e.g., "User can complete X in < 2 minutes"]
- [ ] [Measurable outcome — e.g., "Zero errors in Y scenario"]
```

## Rules

- **P1 = Vertical Slice** — A complete, demo-able feature, not just backend or frontend
- **WHEN/THEN is code** — If you can't write it as a test, rewrite it
- **Requirement IDs are mandatory** — Every story maps to trackable IDs
- **Edge cases matter** — What breaks? What's empty? What's huge?
- **Out of Scope prevents creep** — If it's not here, it doesn't get built
- **Never ask clarifying questions while writing.** Flag vagueness with `⚠️ VAGUE`; bounce at sign-off.
- **Atomize scenarios.** A single scenario from grilling can become multiple WHEN/THEN clauses — split until each clause is independently testable. Each clause gets its own ID.
