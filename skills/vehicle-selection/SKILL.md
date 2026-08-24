---
name: vehicle-selection
description: The execution-vehicle rubric - decides silently how each plan phase runs (single agent, parallel sub-agents, agent team, background session, dynamic workflow or goal-loop) and which model tier it uses. Use while drafting or reviewing plan phases; never prompt the user for a vehicle.
---

# Execution-vehicle selection

The full rubric ships with this plugin. Read it before assigning a vehicle to any
plan phase:

`${CLAUDE_PLUGIN_ROOT}/.claude/rules/vehicle-selection.md`

Two rules that hold regardless:

- Vehicle inference is **always silent**. Asking the user which vehicle to use is a
  kill criterion, not a clarifying question.
- Every phase gets a vehicle and a model tier. `/plan-review` flags an
  under-specified vehicle and a phase routed to a needlessly expensive tier.

The planning rulebook this serves is in the [[universal-planning]] skill.
