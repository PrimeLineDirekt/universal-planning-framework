---
description: Create a new plan using the Universal Planning Framework v3
argument-hint: [description of what to plan]
model: opus
---

# Create New Plan

You are creating a plan for: `$ARGUMENTS`

Follow the Universal Planning Framework v3. Execute all 3 stages in order.

---

## Stage 0: Discovery (Before Planning)

Determine which of the 10 checks to run. Use the intelligence rule: skip checks you can articulate a reason for skipping. Run checks where uncertainty exists.

**Priority tiers:**
- Always consider: 0.1 Existing Work, 0.7 Feasibility, 0.9 Better Alternatives (AHA Effect)
- Usually relevant: 0.2 Factual Verification, 0.3 Official Docs, 0.8 ROI
- Context-dependent: 0.4 Updates Scan, 0.5 Best Practices, 0.6 Deep Research, 0.10 Competitive

**Skip Stage 0 entirely when:** < 3 phases AND < 2h effort AND user said "quick plan".

For each check you run:
1. Use available tools (Read for existing files, WebSearch/WebFetch for research, Grep/Glob for codebase)
2. Document findings briefly
3. Flag anything that changes the approach

Present findings to user via AskUserQuestion:
- "Here's what I found in Stage 0. Any corrections or additions?"
- If AHA Effect found a better alternative, present it clearly

---

## Stage 1: The Plan

After Stage 0 approval, build the plan with these sections:

### 5 CORE Sections (all required):

1. **Context & Why** - Max 3 sentences. WHY this exists, not just what.

2. **Success Criteria** - Measurable outcomes. Include:
   - Specific metrics (not "improve" but "X reaches Y")
   - NOT-scope (what we deliberately exclude)
   - FAILED conditions (kill criteria + timeout)

3. **Assumptions & Validation** - Triple format for each:
   ```
   - [assumption]
     -> VALIDATE BY: [method]
     -> IMPACT IF WRONG: [consequence]
   ```

4. **Phases** - Max 3-4h per phase. Each phase needs:
   - Effort estimate
   - Dependencies
   - Deliverables
   - Binary gate (pass/fail, verifiable - NOT "code complete")

5. **Verification** - Split into:
   - Automated: tests, CI, monitoring
   - Manual: walkthroughs, reviews, user testing

### CONDITIONAL Sections (detect domain, suggest relevant ones):

Auto-detect domain from the description:
- Software: suggest Rollback, Risk, Security, Delegation
- Business: suggest Risk, Budget, Validation, Legal, Timeline, Stakeholders
- Content: suggest Validation, Incremental, Timeline
- Construction: suggest Rollback, Risk, Budget, Legal, Dependencies, Timeline
- Security: suggest Risk, Security, Resume, Stakeholders
- Multi-agent: suggest Risk, Resume, Delegation, Integration

Ask user which conditional sections to include via AskUserQuestion.

---

## Stage 2: Meta

After building the plan:

1. **Delegation Strategy** - Which parts to delegate? What model/agent type?
2. **Research Needs** - Which phases need web research during execution?
3. **Review Gates** - After which phases stop and validate?
4. **Anti-Pattern Check** - Scan against 12 anti-patterns, fix any found

---

## Output

Write the complete plan to a file. Suggest a path based on the project:
- If `.claude/plans/` exists, write there
- Otherwise write to current directory

Include quality grade (C/B/A) at the top of the plan.

---

## Guidelines

- Use AskUserQuestion to gather input at key decision points (Stage 0 findings, conditional section selection, key assumptions)
- Do NOT skip Stage 0 unless criteria met (< 3 phases AND < 2h)
- Challenge the user's first idea (AHA Effect) - is there a better approach?
- Be specific in gates and criteria - no vague "looks good" gates
- Keep phases under 4h - split larger ones
- Every assumption needs VALIDATE BY + IMPACT IF WRONG
- Success criteria need FAILED conditions
