# Craft — TODO

Open items from the honest assessment on 2026-05-13. Ranked by impact for daily UI/FE work, since that's the primary use case.

## 1. Brownfield bootstrap is heavy

7 docs (STACK, ARCHITECTURE, CONVENTIONS, STRUCTURE, TESTING, INTEGRATIONS, CONCERNS) before the first feature. High adoption tax, and ARCHITECTURE/CONVENTIONS rot fast. Consider: which docs are load-bearing for downstream phases vs. nice-to-have? STACK + TESTING + CONCERNS are referenced by name in workflow files; the others may not justify their upfront cost.

---

## What NOT to add

Documented so future me doesn't drift into ceremony:

- More agents/roles (BMad's mistake — solo dev doesn't need PM + Architect + Dev + QA agents)
- More upfront docs in bootstrap (already 7 in brownfield)
- More ceremony in quick mode (the whole point is less)
- Estimation / story points (solo workflow)
- Per-task code review agents (gate check + simplify skill already cover this)
