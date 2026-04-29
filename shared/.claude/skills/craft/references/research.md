# Craft - Research

**Goal**: Use the grill-me skill to interview the user about their feature idea and produce a research document that captures their vision, decisions, references, constraints, and open decisions into `.specs/features/[feature]/research.md` so that Specify can build a crisp PRD on top of it.

## Process

### 1 - Setup the slug and folder
  We can get the slug from multiple places, in this order of precedence:

  1. Get the slug for this feature using `$ARGUMENTS` if provided.
  2. Feature slug mentioned earlier in this session.
  3. `.specs/project/STATE.md` → `Current Feature` (if not `none`).
  4. If none of the above, ask the user for a slug.

  Print the resolved slug on every invocation so the user sees what's active.

  With the slug resolved, create the folder `.specs/features/[slug]` if it doesn't exist.
  Update `.specs/project/STATE.md` adding the slug as content `Current Feature: [slug]`
  If the the slug already exists and we are running the research again, ask the user if this is what he wants, if yes, you can start a new grill session and ask the user if he wants overwrite or push more content to the research document.

### 2 - Run the grill to produce the research document
  1. Invoke the grill-me skill with a prompt that includes the feature slug and any existing information about the user's vision. For example:

  "Research phase for feature `[slug]`. Here's what the user has so far: [one-paragraph summary]. Grill until the decision tree collapses, then return a summary of decisions reached. I will write it to `research.md`."

  2. Produce the `research.md` document in `.specs/features/[slug]/research.md` using the template below. Fill in the Vision, Capabilities, Scenarios, Success Signals, Decisions, Constraints, References, and Out of Scope sections based on the grill-me transcript.

### 3 - Trigger the next step
  The next step in our workflow is specify.

  1. Tell the user that the research is ready and we are going to the next step to create the PRD.
  2. Trigger the next step by using their trigger `Start specify [slug]`


## Template: `.specs/features/[feature]/research.md`

```markdown
# [Feature] Research

**Gathered:** [date]
**Status:** Ready for Specify

## Vision

One-paragraph summary of the user's vision for this feature, based on the grill-me session. Capture the core problem they're trying to solve, their target users, and their high-level approach.

---

## Capabilities

What the user wants to be able to do. Each tagged with priority — `P1` (MVP), `P2` (should have), `P3` (nice to have).

- **[P1]** [Capability — one sentence]
- **[P2]** [Capability]
- **[P3]** [Capability]

---

## Scenarios

Concrete walkthroughs, pre-shaped for direct conversion into WHEN/THEN/SHALL acceptance criteria. One block per significant interaction.

### [Scenario name]

- **WHEN** [trigger/event] **THEN** [expected system response]
- **Edge:** [what breaks — empty input, huge input, invalid type, timeout, race, auth failure, etc.]

### [Scenario name]

- **WHEN** [trigger] **THEN** [response]
- **Edge:** [failure mode]

---

## Success Signals

Measurable outcomes that prove this feature is working. Concrete numbers/thresholds, not vibes.

- [Outcome with metric — e.g., "User completes checkout in <2 minutes"]
- [Outcome — e.g., "Zero auth errors in production for the first week"]

---

## Decisions

Concrete decisions the user has already made. Locked — Specify treats as gospel.

- [Decision in one sentence]
- [Decision in one sentence]

---

## Constraints

Non-functional limits the user mentioned (perf, budget, deadlines, compliance, platform).

- [Constraint]

---

## References

Existing systems, prior art, links, mockups, or related docs the user pointed to during the grill.

- [Reference + why it's relevant]

---

## Out of Scope

Things explicitly excluded.

- [Item]: [why excluded]


```
