---
description: Create a new plan using the Universal Planning Framework
argument-hint: [description of what to plan]
model: opus
---

# Create New Plan

You are creating a plan for: `$ARGUMENTS`

Follow the Universal Planning Framework. Execute all stages in order.

---

## Stage 0: Discovery (Before Planning)

Determine which of the 12 checks to run. Use the intelligence rule: skip checks you can articulate a reason for skipping.

**Priority tiers:**
- Always: 0.1 Existing Work, 0.7 Feasibility, 0.9 Better Alternatives (AHA Effect)
- Always (coding domains): + 0.3 Official Docs
- Usually: 0.2 Factual Verification, 0.3 Official Docs, 0.8 ROI
- Context-dependent: 0.4 Updates Scan, 0.5 Best Practices, 0.6 Deep Research, 0.10 Competitive, 0.11 Constraint Discovery, 0.12 People Risk

**Skip Stage 0 entirely when:** < 3 phases AND < 2h effort AND fully reversible AND user said "quick plan".

For each check you run:
1. Use available tools (Read for existing files, WebSearch/WebFetch for research, Grep/Glob for codebase)
2. Document findings briefly
3. Flag anything that changes the approach

Present findings to user via AskUserQuestion:
- "Here's what I found in Stage 0. Any corrections or additions?"
- If AHA Effect found a better alternative, present it clearly

---

## Stage 1: The Plan

After Stage 0 approval, build the plan.

### Detect Domain (8 domains)

Determine which domain(s) apply:
- Software Development, Multi-Agent / AI System, Business / Strategy, Content / Marketing
- Infrastructure / DevOps, Data & Analytics, Research / Exploration, Multi-Domain

Domain affects: phase sizing, review frequency, required CONDITIONAL sections.

### End State

Before sections, write 1 paragraph describing what concretely exists after the plan succeeds. Not metrics (Success Criteria), not tasks (Phases) - the outcome.

### Plan Confidence Level

Assign at plan header: **High** (all validated) / **Medium** (1-2 unknowns, default) / **Low** (core assumption unvalidated). Low = Phase 1 must be validation sprint.

### 5 CORE Sections (all required):

1. **Context & Why** - Max 3 sentences. WHY this exists, not just what.

2. **Success Criteria** - Measurable outcomes. Include:
   - Specific metrics (not "improve" but "X reaches Y")
   - NOT-scope (what we deliberately exclude)
   - FAILED conditions (kill criteria + timeout) - MANDATORY

3. **Assumptions & Validation** - Triple format for each:
   ```
   - [assumption]
     -> VALIDATE BY: [method]
     -> IMPACT IF WRONG: [consequence]
   ```

4. **Phases** - Each phase needs:
   - **Coding domains**: Scope (files/features), deliverable, binary gate, review checkpoint
   - **Non-coding domains**: Effort estimate (rough guide), deliverable, binary gate
   - Gates must be binary (pass/fail, verifiable - NOT "code complete" or "looks good")
   - Review Checkpoint every 2 phases (coding) or per milestone (non-coding)

5. **Verification** - Split into three:
   - **Automated**: tests, CI, linters (point-in-time)
   - **Manual**: walkthroughs, reviews, user testing (point-in-time)
   - **Ongoing Observability**: production metrics, alerts, health checks

### 18 CONDITIONAL Sections (detect domain, suggest relevant ones):

Auto-include based on detected domain:
- **Software**: Rollback, Risk, Post-Completion, Delegation, Dependencies, Reference Library
- **AI/Agent**: Risk, Delegation, Security, Post-Completion, Dependencies, Reference Library
- **Business**: Timeline, Budget, Stakeholders, User Validation
- **Content**: Timeline, User Validation, Legal, Feedback Architecture
- **Infrastructure**: Rollback, Risk, Dependencies, Post-Completion, Resume Protocol, Reference Library
- **Data & Analytics**: Dependencies, Risk, Rollback, Legal, Security, Post-Completion, Reference Library
- **Research**: Incremental Delivery, Budget, Related Work, Post-Completion, Risk, Learning & Knowledge Capture

Additional sections available: Resume Protocol (>10h), Incremental Delivery (>5 phases), Related Work, Stakeholders, Security, Legal, Feedback Architecture, Learning & Knowledge Capture, Completion Gate (multi-file changes, system integration, artifact registration needed).

**Reference Library** (mandatory for Software, Data, Infrastructure with 3+ phases): List official docs and best practices consulted. Format: `[source] | [version/date] | [what it informed] | [link]`.

Ask user which conditional sections to include via AskUserQuestion.

---

## Stage 1.5: Autonomous Hardening

After building the plan, stress-test it from 6 adversarial perspectives WITHOUT asking the user:

1. **Outside Observer** - Goal clear in 15 words? End State present? Metrics unambiguous?
2. **Pessimistic Risk Assessor** - Single failure point? FAILED conditions have timeouts? Buffer sufficient?
3. **Pedantic Lawyer** - Any gate says "looks good", "complete", "done"? Delegation has deliverable format?
4. **Skeptical Implementer** - First blocker tomorrow? Weakest assumption? Unverified facts?
5. **The Manager** - >10h without Resume Protocol? Scope realistic? Deadlines acknowledged?
6. **Devil's Advocate** - AHA check done? Core assumption could be wrong? 80/20 simpler path?

**Fix in place**: vague gates, missing FAILED conditions, missing VALIDATE BY, missing sections.
**Note for user** (as `[Stage 1.5 Note:]`): strategic concerns, alternatives, scope changes.

Run Discovery Consolidation: verify every Stage 0 finding is addressed or dismissed.

---

## Stage 2: Meta (7 Checks)

1. **Delegation Strategy** - Which parts to delegate? What model/agent type?
2. **Research Needs** - Which phases need web research during execution?
3. **Review Gates** - Confirm review checkpoints in place
4. **Anti-Pattern Check** - Scan against 21 anti-patterns (12 Core + 5 AI + 4 Quality), fix any found
5. **Cold Start Test** - Can a fresh agent execute this cold? Self-contained?
6. **Plan Hygiene Protocol** - Define: after each phase, mark gate result, scope changes, assumption updates
7. **Discovery Consolidation** - Every Stage 0 finding addressed or dismissed?

---

## Output

Write the complete plan to a file. Suggest a path based on the project:
- If `.claude/plans/` exists, write there
- Otherwise write to current directory

Include at the top: Quality Grade (C/B/A), Confidence Level (High/Medium/Low), date.

---

## Guidelines

- Use AskUserQuestion at key decision points (Stage 0 findings, conditional sections, assumptions)
- Challenge the user's first idea (AHA Effect) - is there a better approach?
- Be specific in gates and criteria - no vague "looks good" gates
- Every assumption needs VALIDATE BY + IMPACT IF WRONG
- Success criteria MUST have FAILED conditions
- For coding domains: scope-based phases, Reference Library mandatory (3+ phases)
- Review Checkpoints every 2 phases for coding domains
- 21 anti-patterns to check (not 12)
- 8 domains to detect (not 6)
