---
description: Autonomously stress-test and harden a plan through 6 adversarial perspectives
argument-hint: [plan-file-path] [--team]
model: sonnet
---

# Autonomous Plan Hardening (Stage 1.5)

You are hardening this plan: `$ARGUMENTS`

Read the plan file and stress-test it from 6 adversarial perspectives. Fix what you can, flag what needs user input. Do NOT ask the user any questions - work autonomously.

---

## Pre-Flight Checks

1. **Read the plan file** using the Read tool
2. **Check idempotency**: If a "Hardening Log" section already exists, inform the user and stop (plan already hardened)
3. **Count phases**: If < 3 phases, inform the user that hardening is designed for complex plans and offer to proceed anyway
4. **Detect domain**: Determine which of the 8 domains apply:
   - Software Development, Multi-Agent / AI System, Business / Strategy, Content / Marketing
   - Infrastructure / DevOps, Data & Analytics, Research / Exploration, Multi-Domain

---

## Mode Selection

**Simple mode (default):** Single-agent, sequential. You role-switch through all 6 perspectives yourself.

**Team mode (`--team` flag):** Only when `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is set:
- Spawn 6 agents (one per perspective), each reads the ORIGINAL plan in parallel
- Collect findings, deduplicate, resolve conflicts
- Conservative fix wins. Pedantic Lawyer takes priority on gates.
- Apply fixes, run consolidation check, append Hardening Log

If `--team` is in the arguments but the env var is not set, fall back to simple mode with a note.

---

## 6 Perspectives (Simple Mode - Sequential)

For each perspective, read the plan through that lens. Record findings and fixes.

### Perspective 1: Outside Observer

"I'm reading this plan for the first time with no context."

- Can I summarize the goal in 15 words or fewer?
- Are success metrics unambiguous? Would two people measure them the same way?
- Is there an End State paragraph? Can I picture what success looks like?
- Are all abbreviations and jargon defined?
- Does Context & Why explain WHY, not just WHAT?

### Perspective 2: Pessimistic Risk Assessor

"Everything that can go wrong, will go wrong."

- What single failure kills this entire plan?
- If the largest phase fails, can we recover? Is there a rollback?
- Do FAILED conditions have concrete timeouts (not "eventually")?
- Is the timeline realistic? Is buffer sufficient (20%+)?
- Are there single points of failure in dependencies?
- For plans >10h: is there a Resume Protocol?

### Perspective 3: Pedantic Lawyer

"Show me the contract. Every word matters."

- Does ANY gate contain subjective words: "looks good", "complete", "done", "acceptable", "sufficient", "ready"?
- For each delegation: is there a defined deliverable format and verification method?
- Does the plan end at deploy/publish/submit? (anti-pattern #5)
- Is NOT-scope explicit enough? Could someone argue a feature is "in scope"?
- Are FAILED conditions truly binary (measurable, not judgment)?

### Perspective 4: Skeptical Implementer

"I start implementing tomorrow morning. What breaks first?"

- What's the first concrete blocker at 9am tomorrow?
- Which assumption has the weakest evidence?
- Which gate requires input that isn't produced by a previous phase or listed in dependencies?
- Are there statements presented as facts that are actually assumptions? (anti-pattern #21)
- For coding domains: is there a Reference Library? Are official docs cited?
- Can I start Phase 1 with ONLY the information in this plan? (Cold Start Test)

### Perspective 5: The Manager

"Is this realistic? Will it actually ship?"

- Is total effort > 10h without a Resume Protocol? (anti-pattern #6)
- Is the scope realistic for the stated timeline and resources?
- Is NOT-scope preventing scope creep? Are there boundary items that could drift in?
- Are hard deadlines acknowledged with consequences?
- For plans > 5 phases: is there Incremental Delivery with stopping points?
- Are there review checkpoints in the phases? (Required for coding domains)
- Does the plan have a Completion Gate for when execution finishes? (Required for multi-file, integration work)

### Perspective 6: Devil's Advocate

"Is this even the right thing to build?"

- Was Stage 0 AHA check (0.9) actually done? Or did the plan start with a predetermined approach?
- What if the core assumption is wrong? Is IMPACT IF WRONG truly understood?
- Is there an 80/20 simpler path that delivers most value with less effort?
- What makes this approach obsolete in 6 months?
- Were alternatives genuinely considered, or just listed for compliance?

---

## Mutation Rules

After collecting all findings across 6 perspectives:

**Fix in place (structural fixes):**
- Vague gate text - replace with objective, observable criteria
- Missing FAILED conditions - add measurable kill criteria with timeout
- Missing VALIDATE BY on assumptions - add validation method
- Missing CONDITIONAL sections required by domain - add skeleton section
- Unclear phase scope - add scope descriptor
- Unverified facts - flag with `[Unverified]` marker

**Do NOT mutate (strategic decisions - note for user):**
- Adding, removing, or reordering phases
- Changing strategic direction or approach
- Modifying NOT-scope decisions
- Overriding Stage 0 discoveries
- Changing user's explicit choices
- If you find a better alternative approach, note it as `[Stage 1.5 Note:]`

---

## Discovery Consolidation Check

After all 6 perspectives, run this final check:

1. Read the Stage 0 Summary section
2. List every finding/discovery mentioned
3. Verify each is either:
   - Addressed in the plan (referenced in a phase, assumption, or decision)
   - Explicitly dismissed with a stated reason
4. Flag any "orphaned" discoveries (anti-pattern #20: Discovery Amnesia)

---

## Apply Changes and Build Hardening Log

1. Apply all structural fixes directly to the plan content
2. Append a `## Stage 1.5: Hardening Log` section at the end with:

```markdown
## Stage 1.5: Hardening Log

**Ran**: [date] | **Mode**: Simple / Team | **Perspectives**: [N]/6

| Perspective | Finding | Action Taken |
|---|---|---|
| [perspective name] | [what was found] | [Fixed: description] or [Stage 1.5 Note: description] |
| ... | ... | ... |

**Discovery Consolidation**: [All Stage 0 findings addressed / N findings orphaned - see notes]
```

3. Write the hardened plan back to the original file

---

## Terminal Summary

After writing the hardened plan, print a summary:

```
Plan Hardened: [filename]
Domain: [detected]
Perspectives: 6/6
Structural fixes: [count]
Notes for user: [count]
Discovery consolidation: [pass/fail]
```

---

## Guidelines

- **Be specific**: Quote the problematic text when fixing gates or assumptions
- **Be conservative**: When in doubt, note for user rather than fix in place
- **Be thorough**: Every perspective should produce at least 1 finding on a complex plan
- **Preserve intent**: Fix the expression, not the strategy
- **Check all 21 anti-patterns**: Cross-reference findings against the anti-pattern list
- **Domain-aware**: Check for domain-specific required sections (Reference Library for coding, Resume Protocol for long plans, etc.)
