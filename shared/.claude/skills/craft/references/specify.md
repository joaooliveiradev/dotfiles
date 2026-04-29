# Craft — Specify

**Goal**: Read `.specs/features/[slug]/research.md` and transform it into a formal, testable PRD at `.specs/features/[slug]/spec.md`. Specify is a translator, not an interviewer — **no clarifying questions are asked**.

## Process

### 1. Load research.md

Load `.specs/features/[slug]/research.md` in full. It is the only input source. If it doesn't exist, stop and ask the user to run Research first (`Start feature [slug]`).

### 2. Transform — research → spec

Each research field maps to a spec section:

| research.md             | spec.md                                                       |
| ----------------------- | ------------------------------------------------------------- |
| Vision                  | Problem Statement + Goals                                     |
| Capabilities (P1/P2/P3) | One User Story per capability, priority preserved             |
| Scenarios (WHEN/THEN)   | Acceptance Criteria — atomized into precise testable clauses  |
| Scenarios (Edge)        | Edge Cases section                                            |
| Success Signals         | Success Criteria                                              |
| Constraints             | Non-Functional Requirements                                   |
| Out of Scope            | Out of Scope (direct copy)                                    |
| Decisions               | Inline notes/assumptions; mostly informs Plan                 |
| References              | References section at the spec footer                         |

**Atomization rule**: a single scenario in research can become multiple WHEN/THEN clauses in spec — split until each clause is independently testable. Cover happy path, the edge from research, and any obvious validation/error response that follows from the scenario. Each clause gets its own ID (`[FEAT]-[STORY].[CLAUSE]`) so tasks can claim individual clauses, not whole stories.

**Vagueness rule**: if a scenario or capability is too vague to atomize, do **not** ask the user. Insert `⚠️ VAGUE: [what's unclear]` inline where the gap lives, and surface every flag at the top of the spec when presenting it. The user catches them at sign-off and bounces back to Research if needed.

### 3. Assign IDs and build traceability

Generate `[CATEGORY]-[NUMBER]` IDs for every requirement (e.g., `AUTH-01`, `CART-03`, `NOTIF-02`). Build the traceability table linking IDs → stories → status. Status starts as `Pending`.

### 4. Present for sign-off

Show the user the completed `spec.md` plus a summary of any `⚠️ VAGUE` flags. Two outcomes:

- **Approved** → trigger Plan with `Start plan [slug]`.
- **Rejected** → bounce back to Research with the specific gaps. Do not iterate inside Specify.

## Rules

- **Never ask the user clarifying questions.** Research is the contract. Missing → flag, then bounce.
- Every P1 story must be independently testable.
- Requirement IDs are mandatory.
- Do not describe HOW to build — that's Plan's job.
- Vagueness is documented (`⚠️ VAGUE: ...`), never resolved here.

---

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

Constraints and quality bars carried over from research. Plan must respect these.

- [Constraint — e.g., "P95 latency < 200ms for /search"]
- [Constraint — e.g., "Must support offline mode on mobile"]
- [Constraint — e.g., "WCAG 2.1 AA accessibility"]

---

## Requirement Traceability

Each acceptance clause gets a unique ID for tracking across plan, tasks, and validation. One row per WHEN/THEN clause — not per story — so tasks can claim individual clauses and orphans become detectable.

| Clause ID  | Story       | Clause                        | Status  |
| ---------- | ----------- | ----------------------------- | ------- |
| [FEAT]-01.1 | P1: [Story] | WHEN [event] THEN [behavior] | Pending |
| [FEAT]-01.2 | P1: [Story] | WHEN [event] THEN [behavior] | Pending |
| [FEAT]-01.3 | P1: [Story] | WHEN [edge] THEN [handling]  | Pending |
| [FEAT]-02.1 | P2: [Story] | WHEN [event] THEN [behavior] | Pending |

**ID format:** `[CATEGORY]-[STORY].[CLAUSE]` (e.g., `AUTH-01.1`, `CART-03.2`, `NOTIF-02.1`). Story number groups clauses; clause number is local to the story.

**Status values:** Pending → In Plan → In Tasks → Implementing → Verified

**Coverage:** X total, Y mapped to tasks, Z unmapped ⚠️

---

## Success Criteria

How we know the feature is successful (carried over from Success Signals in research):

- [ ] [Measurable outcome — e.g., "User can complete X in < 2 minutes"]
- [ ] [Measurable outcome — e.g., "Zero errors in Y scenario"]

---

## References

- [Reference + why it's relevant]
```

## Tips

- **P1 = Vertical Slice** — A complete, demo-able feature, not just backend or frontend
- **WHEN/THEN is code** — If you can't write it as a test, rewrite it
- **Requirement IDs are mandatory** — Every story maps to trackable IDs
- **Edge cases matter** — What breaks? What's empty? What's huge?
- **Out of Scope prevents creep** — If it's not here, it doesn't get built
- **No clarification loop** — vagueness is flagged inline and surfaced at sign-off, never resolved by re-asking the user
