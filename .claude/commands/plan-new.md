---
description: Deep interview about a plan to uncover edge cases and refine approach
argument-hint: [plan-file-path]
model: opus
---

# Interview Plan Command

Read the plan file at `$ARGUMENTS` and conduct a thorough interview using the AskUserQuestion tool.

## Pre-Interview: Detect Domain & Scope

Before asking questions, scan the plan and determine:

1. **Domain:** Software / Business / Content / Construction / Multi-Domain
2. **Complexity:** Simple (<3 phases) / Standard (3-6 phases) / Complex (>6 phases)
3. **Framework version:** Does the plan use Universal Planning Framework v3 sections?

This determines which Focus Areas to prioritize and how deep to go.

---

## Interview Focus Areas

### Always Cover (All Domains)

**Tradeoffs & Alternatives:**
- Why this approach over simpler alternatives?
- What are you optimizing for (speed, cost, reliability, learning)?
- What complexity is this introducing?
- What are you explicitly NOT doing and why?

**Dependencies & Prerequisites:**
- What must be true for this to work?
- What external systems, data, or access are required?
- What happens if dependencies change or become unavailable?

**Assumptions & Validation:**
- "You assume X  - what if it doesn't hold?"
- "Why are you confident about Y?"
- "What evidence supports Z?"
- "What's the IMPACT IF WRONG for your riskiest assumption?"

**Risks & Mitigation:**
- What could derail this plan?
- Where are the single points of failure?
- What's the contingency if key risks materialize?
- What's the earliest signal that something is going wrong?

**Verification & Success:**
- How will you know each phase succeeded?
- What can be tested automatically vs manually?
- How do you test failure scenarios?
- Do your success criteria have clear FAILED conditions?

### Domain-Specific (Add Based on Detection)

**Software / AI Systems:**
- How will critical paths actually work at system boundaries?
- Where could race conditions, timing issues, or state conflicts occur?
- What are performance characteristics under load?
- How does this get deployed safely? What monitoring is needed?
- How do you rollback if things go wrong?

**Business / Strategy:**
- How will you validate market demand before full commitment?
- What are the unit economics? At what scale does this work?
- How might competitors respond?
- What's the minimum viable test before investing fully?

**Content / Marketing:**
- Who is the specific audience and how do you reach them?
- What's the distribution strategy beyond "publish"?
- How will you measure resonance vs vanity metrics?
- What's the feedback loop to iterate on content?

**Construction / Operations:**
- What safety protocols are required?
- Which permits or inspections are needed and what's their lead time?
- What happens if materials or labor are delayed?
- How do you handle weather, site conditions, or supply chain disruptions?

---

## Interview Guidelines

**Make questions probing, not obvious:**
- BAD: "Have you thought about testing?" (too generic)
- GOOD: "Your Phase 2 gate says 'API works'  - what specific test proves that under concurrent load?"
- GOOD: "You assume the external API has 99.9% uptime  - have you checked their actual status page for the last 90 days?"

**Challenge assumptions explicitly:**
- "You assume X will work  - what happens to Phase 3 if it doesn't?"
- "The plan lists no FAILED conditions  - what would make you kill this project?"
- "Your assumption has no IMPACT IF WRONG  - what's the blast radius if this is false?"

**Probe gates and verification:**
- "Your gate for Phase 1 is 'code complete'  - that's not verifiable. What test proves it works?"
- "All your verification is manual  - what can be automated?"
- "What's the earliest point you can detect this isn't working?"

**Explore edge cases:**
- "What happens when [X] and [Y] fail simultaneously?"
- "How does this behave if the user does [unexpected thing]?"
- "What breaks when [dependency] returns unexpected data?"

**Follow the energy:**
- When answers are confident and detailed → move on
- When answers are vague or uncertain → dig deeper
- When "I haven't thought about that" → this is gold, explore it fully

---

## Interview Length

**Target:** 8-15 questions for a standard plan. Adjust based on complexity:
- Simple plan (<3 phases): 5-8 questions
- Standard plan (3-6 phases): 8-15 questions
- Complex plan (>6 phases): 12-20 questions

**Minimum coverage:**
- Every Assumption challenged at least once
- Every Phase gate questioned for verifiability
- At least one "what if this fails completely?" scenario explored

**Stop when:**
- All CORE sections have been probed
- No answers reveal new unknowns
- User signals they're ready to move on

---

## When to Recommend Replanning

If the interview reveals any of these, don't patch the plan  - recommend returning to Stage 0:

- A core assumption is provably wrong
- Success criteria remain unmeasurable even after clarification
- The AHA Effect applies (fundamentally better approach discovered during interview)
- Estimated effort exceeds original by >3x after uncovering hidden complexity
- Multiple CORE sections need complete rewrites

**How to communicate:**
```
"Based on our interview, I'd recommend stepping back to Stage 0 rather than patching
this plan. Here's why: [specific findings]. The core [assumption/approach/scope] has
shifted enough that a fresh plan would be more efficient than layering fixes."
```

---

## After Interview: Update Plan

### Step 1: Framework Compliance Check

Before updating, verify the plan against Universal Planning Framework v3:

- [ ] Success Criteria have FAILED conditions (kill criteria + timeout)?
- [ ] Every Assumption has VALIDATE BY + IMPACT IF WRONG?
- [ ] Every Phase has a binary Gate (pass/fail, verifiable)?
- [ ] Verification is split into Automated + Manual?
- [ ] Relevant CONDITIONAL sections activated for this domain?
- [ ] No anti-patterns present (#1-#12)?

Flag any gaps in the Refinements section below.

### Step 2: Add Interview Sections

**1. Decisions Made (NEW section)**
```markdown
## Decisions Made

- [Decision]: [chosen approach]
  → Alternatives considered: [what else was evaluated]
  → Rationale: [why this won]
  → Tradeoff: [what we're giving up]
```

**2. Risks & Mitigations (enhance existing or add)**
```markdown
## Risks & Mitigations

- [Risk]: [description]
  → Likelihood: [high/medium/low]
  → Mitigation: [specific strategy]
  → Contingency: [what if mitigation fails]
  → Detection: [earliest signal this is happening]
```

**3. Implementation Refinements (NEW section)**
```markdown
## Implementation Refinements

- [Clarification]: [details added after interview]
- [Edge Case]: [scenario → how we handle it]
- [Framework Gap]: [missing v3 element → added/fixed]
```

**4. Additional Requirements (append)**
```markdown
## Additional Requirements

- [Requirement]: [discovered during interview]
- [Dependency]: [previously overlooked]
- [Constraint]: [newly identified limitation]
```

---

## CRITICAL  - Plan Integrity Rules

**NEVER remove or modify existing tasks from the original plan.**

The original task list is the immutable baseline. Interview insights are ADDITIVE:

- **Correct**: Add [Clarified] notes below existing tasks
- **Correct**: Append new sections (Decisions, Risks, Refinements)
- **Correct**: Add to "Additional Requirements"
- **Correct**: Flag framework compliance gaps in Refinements
- **Wrong**: Rewrite existing tasks
- **Wrong**: Remove tasks that seem redundant
- **Wrong**: Restructure the original plan
- **Wrong**: Change Phase order or merge Phases

**Example of proper clarification:**
```markdown
## Original Plan
- Phase 2: Implement authentication

[Clarified after interview]
- Using OAuth 2.0 with PKCE flow
- Session timeout: 30 minutes
- Refresh token rotation enabled
- Rate limiting: 5 failed attempts = 15min lockout
- Gate updated: "User can log in, receive token, and access protected route in E2E test"
```

**Exception:** If recommending replanning (see above), clearly state this is a replan recommendation, not an edit.
---

## Context: Universal Planning Framework v3

This command is part of the Universal Planning Framework, which defines:

- **5 CORE sections:** Context, Success Criteria (with FAILED), Assumptions (with IMPACT IF WRONG), Phases (with Gates), Verification (Auto + Manual)
- **14 CONDITIONAL sections:** Rollback, Risk, Post-Completion, Budget, User Validation, Legal, Security, Resume Protocol, Incremental Delivery, Delegation, Dependencies, Related Work, Timeline, Stakeholders
- **12 anti-patterns** with detection rules and fixes
- **Quality rubric:** C (viable) / B (solid) / A (excellent)
- **Replanning triggers:** Gate fails, assumption wrong, buffer exceeded, new blocker, user pivots

The interview should help elevate the plan's quality grade and ensure all relevant sections are present before implementation begins.

---

## Usage

```bash
/interview-plan path/to/plan.md
```

The interview is conducted interactively using the AskUserQuestion tool. Take your time and be thorough  - a good interview saves hours or days of implementation problems.