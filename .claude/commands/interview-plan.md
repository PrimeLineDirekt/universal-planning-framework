---
description: Interview a plan using framework-aware questions across 3 depth tiers
argument-hint: [plan-file] [--self]
model: opus
---

# Plan Interview

You are interviewing this plan: `$ARGUMENTS`

Read the plan file and conduct a framework-aware interview. Questions are generated based on the Universal Planning Framework, not generic templates.

---

## Mode Selection

**Interactive mode (default):** Ask the user questions via AskUserQuestion, one tier at a time.

**Self-interview mode (`--self` flag):** Claude answers its own questions autonomously. Useful for hardening a plan without human input. Write answers directly, flag low-confidence answers with `[Low confidence]`.

---

## Pre-Flight

1. **Read the plan file** using the Read tool
2. **Detect domain**: Software, AI/Agent, Business, Content, Infrastructure, Data & Analytics, Research, Multi-Domain
3. **Identify plan grade**: Check which CORE/CONDITIONAL sections exist, estimate current grade (C/B/A)
4. **Scan for anti-patterns**: Quick check against 21 anti-patterns to inform question generation

---

## Question Generation (3 Tiers)

### Tier 1: Critical Gaps (ask first)

Questions about missing or weak CORE sections. These block implementation.

| Gap Type | Example Question |
|----------|-----------------|
| Missing FAILED conditions | "What kills this project? After how long without progress do you pull the plug?" |
| Vague success criteria | "You say 'improve performance' - what specific number makes this a success vs. failure?" |
| Unvalidated assumptions | "You assume [X] - how will you verify this before Phase [N] depends on it?" |
| No rollback on irreversible change | "If Phase [N] breaks production, what's the undo plan? How long does rollback take?" |
| Missing VALIDATE BY | "Assumption [X] has no validation method. How would you test this cheaply before committing?" |
| Assumed facts (#21) | "You state [X] as fact - is this verified or an assumption? What's the source?" |

### Tier 2: Domain-Specific Probes (ask second)

Questions triggered by the detected domain:

**Software/AI:** "Which official docs did you consult? Is there a Reference Library?" | "What's the review checkpoint cadence?" | "Are phases scoped by files/features or just time estimates?"

**Business:** "Who are the stakeholders that need to approve before Phase [N]?" | "What's the budget ceiling where you stop and re-evaluate?" | "What does the customer validation signal look like?"

**Content:** "What feedback loop exists between published content and the next piece?" | "What's the legal review process?" | "How do you measure 'good enough' to publish?"

**Infrastructure:** "What's the rollback time? Under 5 minutes?" | "Is there a Resume Protocol for multi-session work?" | "What monitoring proves this keeps working after deploy?"

**Data:** "What are the data quality gates between phases?" | "Is there a baseline for comparison?" | "What's the data contract with downstream consumers?"

**Research:** "What constitutes a valid null result?" | "Where are findings captured for future reference?" | "What's the time-boxed FAILED condition?"

### Tier 3: Quality Strengthening (ask last)

Questions that push a plan from Grade B toward Grade A:

- "If you had to explain this plan to someone with zero context, what would they misunderstand first?" (Cold Start Test)
- "What's the 80/20 version - which 20% of this delivers 80% of the value?" (AHA Effect probe)
- "What makes this approach obsolete in 6 months?" (Devil's Advocate)
- "Which phase, if it fails, cascades into the most damage?" (Risk assessment)
- "What did Stage 0 discover that ISN'T reflected in the plan?" (Discovery Consolidation, anti-pattern #20)
- "Are there numbers in this plan without sources?" (anti-pattern #15)
- "Any gates that use judgment words like 'acceptable', 'sufficient', 'ready'?" (anti-pattern #18)

---

## Anti-Pattern Cross-Reference

When a question reveals an issue, reference the specific anti-pattern:

| Finding | Anti-Pattern |
|---------|-------------|
| No kill criteria | #11 Zombie Project |
| Vague metrics | #3 Vague Success |
| Untested assumption | #1 Unvalidated Assumptions |
| No alternatives considered | #10 First Idea = Final |
| Stage 0 skipped | #9 Skipping Stage 0 |
| Facts without sources | #21 Assumed Facts |
| AI estimates without iteration buffer | #16 Hallucinated Effort |
| Judgment words in gates | #18 Unverifiable Gates |
| Discovery findings missing from plan | #20 Discovery Amnesia |
| Delegation without input spec | #17 Delegation Without Context |

---

## Interview Flow

1. Start with Tier 1 (critical gaps) - ask 2-4 questions
2. Move to Tier 2 (domain-specific) - ask 2-3 questions
3. Finish with Tier 3 (quality strengthening) - ask 1-2 questions
4. After each tier, update the plan with discoveries
5. Continue until all tiers covered or user says "enough"

In `--self` mode: answer all questions yourself, write updates directly.

---

## Plan Update Rules

After the interview, update the plan file with discoveries.

**CRITICAL - Plan Integrity Rules:**
- NEVER remove or modify existing content from the original plan
- ONLY ADD new sections: Interview Decisions, Discovered Risks, Refinements
- If a task needs clarification, add a `[Clarified]` note BELOW the task, don't rewrite it
- Original plan = immutable baseline
- New discoveries = append to "Interview Findings" section
- Reference which anti-pattern prompted each finding

---

## Output

After completing the interview, append an `## Interview Log` section to the plan:

```markdown
## Interview Log

**Date**: [date] | **Mode**: Interactive / Self | **Domain**: [detected]
**Questions asked**: [count] | **Anti-patterns found**: [count]

| Tier | Question | Answer/Decision | Anti-Pattern |
|------|----------|----------------|-------------|
| 1 | [question] | [answer] | #[N] or - |
| ... | ... | ... | ... |

**Plan changes made**: [list of additions/clarifications]
**Grade before**: [C/B/A] | **Grade after**: [C/B/A]
```
