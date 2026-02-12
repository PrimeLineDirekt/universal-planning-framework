# Universal Planning Framework

**A 3-stage thinking process evolved from 117 plans + 195 handoffs. Catches gaps that only surface during execution.**

## The Problem

Critical insights are consistently found AFTER initial planning - during interviews, execution, or post-mortem. What's missing from plans IS what gets discovered painfully during execution.

## The Framework

### Stage 0: Before Plan (Discovery & Sparring)

Runs BEFORE writing a single line of the plan. Not a rigid checklist - a thinking toolkit.

**10 Discovery Checks:**

1. **Existing Work Audit** - What already exists? Files, code, docs, prior art?
2. **Factual Verification** - Are the user's claims/assumptions correct?
3. **Official Docs Check** - Authoritative sources consulted? API docs, legal reqs?
4. **Online Updates Scan** - Has anything changed? New versions, deprecated features?
5. **Best Practices Research** - What do experts recommend?
6. **Deep Research Decision** - Should we do thorough web research BEFORE planning?
7. **Sparring: Feasibility** - Is this even possible as described?
8. **Sparring: ROI** - Is this worth doing? Cost vs. benefit?
9. **Sparring: Better Alternatives (AHA Effect)** - Is there a fundamentally better approach?
10. **Competitive Landscape** - Who else solved this? What can we learn?

**Priority tiers:**

| Tier | Checks | When |
|------|--------|------|
| Always consider | 0.1 Existing Work, 0.7 Feasibility, 0.9 Better Alternatives | Every non-trivial plan |
| Usually relevant | 0.2 Factual Verification, 0.3 Official Docs, 0.8 ROI | Most plans |
| Context-dependent | 0.4 Updates Scan, 0.5 Best Practices, 0.6 Deep Research, 0.10 Competitive | When domain signals it |

**Skip Stage 0 when:**
- Plan is < 3 phases AND < 2h effort
- User explicitly says "quick plan", "skip discovery", or "just plan"

### Stage 1: The Plan

**5 CORE Sections (always required):**

1. **Context & Why** - Why this exists, what problem it solves. Max 3 sentences. NOT "improve X" but WHY improve X.
2. **Success Criteria** - Measurable outcomes, not activities. Includes NOT-scope and FAILED conditions (kill criteria + timeout).
3. **Assumptions & Validation** - What we're betting on being true. Format: `[assumption] → VALIDATE BY: [method] → IMPACT IF WRONG: [consequence]`.
4. **Phases** - Ordered stages with effort estimates (max 3-4h each), dependencies, and binary gates. Gate must be verifiable: PASS or FAIL only.
5. **Verification** - How to prove it worked. Always split: Automated (tests, CI, monitoring) + Manual (walkthroughs, reviews).

**14 CONDITIONAL Sections (add when relevant):**

- **Rollback / Undo Strategy** - Trigger, steps, data recovery, duration, point of no return.
- **Risk Assessment** - Likelihood, impact, mitigation, detection trigger per risk.
- **Post-Completion Plan** - Monitor what/how long, maintain schedule, if-fails plan.
- **Budget & Resources** - Costs, ceiling, decision point for re-evaluation.
- **User/Customer Validation** - Who, when, method, minimum signal for pass.
- **Legal & Compliance** - Which regulations, requirements, verification method.
- **Security & Privacy** - Sensitive data, threats, controls, audit method.
- **Resume Protocol** - TL;DR (update each session), context load order, last completed, next action, blockers.
- **Incremental Delivery** - MVP definition, "good enough" threshold, natural stopping points.
- **Delegation & Team Strategy** - Who/what per phase, interface contracts, verification of delegated output.
- **Dependencies & Blockers** - Type, status, fallback, lead time per dependency.
- **Related Work & Integration** - Project, relationship type, coordination needs.
- **Timeline & Deadlines** - Duration per phase with 20%+ buffer, hard deadline + consequence.
- **Stakeholder Communication** - Who needs what info, when, how.

### Stage 2: Meta (4 Checks)

After creating the plan, run:

1. **Delegation Strategy** - Which parts to sub-agents/teams? What model/agent type per phase?
2. **Research Needs** - Which phases need web research during execution? Mark them now.
3. **Review Gates** - After which phases stop and validate? Confirm gates are in place.
4. **Anti-Pattern Check** - Quick scan against 12 anti-patterns. Fix any found.

## Replanning Triggers

Return to Stage 0 (narrowed) when:
- Gate fails and fix changes scope
- Core assumption proves wrong (IMPACT IF WRONG activates)
- Timeline slips beyond buffer
- New dependency or blocker emerges
- Success criteria change due to external factors
- User pivots direction

**Replanning ≠ starting over.** Update what changed → re-evaluate remaining phases → continue.

## 12 Anti-Patterns

| # | Anti-Pattern | Detection Rule | Fix |
|---|-------------|---------------|-----|
| 1 | **Unvalidated Assumptions** | Entries without VALIDATE BY method | Add validation + IMPACT IF WRONG |
| 2 | **All-or-Nothing Phases** | Any phase >4h | Split into 3-4h sub-phases |
| 3 | **Vague Success** | "improve", "better", "enhance" without metrics | Add specific numbers and thresholds |
| 4 | **No Rollback** | Irreversible changes without Rollback section | Add Rollback or confirm reversible |
| 5 | **Plan Ends at Deploy** | Last phase is Deploy/Publish/Submit | Add Post-Completion: monitoring, if-fails |
| 6 | **No Resume Protocol** | >10h effort without Resume section | Add TL;DR, context load order, next action |
| 7 | **Parallel Without Contracts** | Delegation without interface definitions | Define what each stream produces, in what format |
| 8 | **Blind Delegation Trust** | No verification after delegation | Spot-check, cross-reference, count deliverables |
| 9 | **Skipping Stage 0** | Plan starts at Phase 1 without discovery | Most expensive plans skip discovery |
| 10 | **First Idea = Final** | No alternatives considered | Run Check 0.9: better approach exists? |
| 11 | **Zombie Project** | No FAILED conditions, no timeout | Add kill criteria + timeout to Success Criteria |
| 12 | **Timeline Fantasy** | Zero buffer or round-number estimates | Add 20%+ buffer, break into smaller chunks |

## Quality Rubric

| Grade | Criteria |
|-------|----------|
| C (Viable) | All 5 CORE + at least 1 CONDITIONAL. No critical anti-patterns (#3, #9, #11). |
| B (Solid) | C + Stage 0 done + FAILED conditions + delegation strategy. Zero anti-patterns. |
| A (Excellent) | B + sparring (0.7-0.9) + alternatives considered + gates on all phases + resume protocol (if multi-session). Replanning triggers defined. |
| Red Flags | Vague criteria, no Stage 0, assumptions untested, >6 phases without MVP, first idea unchallenged. Fix before implementation. |

## When to Activate

**ALWAYS use for:**
- New features, products, system components
- Architecture changes touching 3+ files
- Multi-phase projects (3+ phases or >2h)
- Anything with external dependencies

**SKIP when ALL true:**
- Single file affected
- No external dependencies
- < 50 lines changed
- No data migration or schema change
- No user-facing behavior change
- Rollback = git revert

## Installation

### Option A: Full Install (Recommended)

Clone this repo and copy the `.claude/` directory into your project:

```bash
git clone https://github.com/YOUR_USERNAME/universal-planning-framework
cp -r universal-planning-framework/.claude/* your-project/.claude/
```

This gives you:
- The planning rule (`.claude/rules/universal-planning.md`)
- `/plan-new` command
- `/plan-review` command
- `planner` agent

### Option B: Minimal Install

Just copy the core rule file:

```bash
curl -o .claude/rules/universal-planning.md \
  https://raw.githubusercontent.com/YOUR_USERNAME/universal-planning-framework/main/.claude/rules/universal-planning.md
```

You can invoke the framework manually by telling Claude "use universal planning framework" or create your own commands.

## Usage

### Start a new plan
```bash
/plan-new "Add OAuth login to Next.js app"
```

Claude will:
1. Run Stage 0 discovery checks
2. Guide you through CORE sections
3. Identify which CONDITIONAL sections you need
4. Generate Stage 2 meta review
5. Assign quality grade

### Review an existing plan
```bash
/plan-review path/to/plan.md
```

Claude will:
1. Check if Stage 0 was run (or do it now)
2. Verify CORE sections are complete and v3-compliant
3. Identify missing CONDITIONAL sections
4. Flag gaps and anti-patterns
5. Suggest improvements with quality grade

### Use the planner agent directly
```bash
/task planner "Create a plan for X using universal planning framework"
```

The `planner` agent runs in plan mode (no file edits) and uses Sonnet for cost efficiency.

## Domain Detection

Framework automatically includes relevant CONDITIONAL sections based on domain:

**Software Development:**
- Dependencies, Risks, Rollback, Testing (via Verification), Monitoring (via Post-Completion)

**Multi-Agent / AI System:**
- Dependencies, Risks, Testing, Monitoring, Delegation, Security

**Business / Strategy:**
- Timeline, Budget & Resources, Communication, User Validation

**Content / Marketing:**
- Timeline, User Validation, Legal & Compliance

**Infrastructure / DevOps:**
- Dependencies, Risks, Rollback, Monitoring, Resume Protocol

**Multi-Domain (2+ above):**
- Union of all relevant sections from matched domains

## Philosophy

**Plans fail because discovery happens too late.**

Traditional planning goes: Goal → Approach → Steps → Execute → Oh crap, we didn't consider X.

This framework inverts it: Discovery → Constraints → Assumptions → THEN plan.

Stage 0 is the most important stage. It's where you find out that:
- Your "simple feature" touches 6 different systems
- The existing code already does 70% of what you need
- Your timeline assumption was off by 3x
- There's a legal requirement you didn't know about

The framework is domain-agnostic. Use it for software features, business launches, content creation, security audits, construction projects - anything that needs a plan.

## Quick Reference

```
STAGE 0 (Before):
  Always:  0.1 Existing Work | 0.7 Feasibility | 0.9 AHA Effect
  Usually: 0.2 Facts | 0.3 Docs | 0.8 ROI
  Maybe:   0.4 Updates | 0.5 Practices | 0.6 Research | 0.10 Competitive
  Skip:    <3 phases AND <2h | user says skip | continuation → "what changed?"

STAGE 1 (Plan):
  CORE:  Context | Success (FAILED) | Assumptions (IMPACT) | Phases (Gates) | Verification (Auto+Manual)
  COND:  Rollback | Risk | Post-Completion | Budget | User Validation | Legal |
         Security | Resume | Incremental | Delegation | Dependencies |
         Related Work | Timeline | Stakeholders

STAGE 2 (Meta):
  M.1 Delegation | M.2 Research Needs | M.3 Review Gates | M.4 Anti-Patterns

REPLAN: Gate fails | Assumption wrong | Buffer exceeded | New blocker | User pivots
```

## Contributing

Found a gap the framework doesn't catch? Open an issue.

Have a great example plan? Submit a PR to `examples/`.

## License

MIT License - see LICENSE file.

---

**Remember: This is a thinking process, not a template. Adapt it to your needs.**
