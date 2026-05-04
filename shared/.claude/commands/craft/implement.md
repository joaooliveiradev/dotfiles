---
description: Run the Implement phase — execute tasks.md via sub-agents (RED → GREEN → gate → commit)
---

Invoke the `craft` skill via the Skill tool (skill: "craft"), then execute the **Start implement** trigger from `SKILL.md`. Load `shared/.claude/skills/craft/references/implement.md` and run that workflow end-to-end.

The slug is read from `STATE.md`. The main agent coordinates only — every task is delegated to a sub-agent.
