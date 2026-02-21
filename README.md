# Universal Planning Framework

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.1-green.svg)]()
[![Works with Claude Code](https://img.shields.io/badge/works%20with-Claude%20Code-orange.svg)]()

**Plans fail because discovery happens too late.** This framework catches gaps that only surface during execution - evolved from 117 real plans + 195 handoffs.

> "Initial idea was a custom booking system (8 weeks). Stage 0 discovered Calendly + Stripe does 90% of it. Shipped in 3 weeks, saved 5 weeks of engineering."
> - from [Business Launch Example](examples/business-launch-plan.md)

## Quick Install

**Full install** (recommended - gives you commands, agent, and rule):
```bash
git clone https://github.com/PrimeLineDirekt/universal-planning-framework
cp -r universal-planning-framework/.claude/* your-project/.claude/
```

**Minimal install** (rule file only):
```bash
mkdir -p .claude/rules
curl -o .claude/rules/universal-planning.md \
  https://raw.githubusercontent.com/PrimeLineDirekt/universal-planning-framework/main/.claude/rules/universal-planning.md
```

## What Makes This Different

**FAILED conditions are mandatory.** Every plan must define when to kill the project - not just when it succeeds. No FAILED condition = zombie project (anti-pattern #11).

**21 anti-patterns with detection rules.** Not guidelines - specific detection rules that catch vague gates ("looks good"), hallucinated estimates, assumed facts, discovery amnesia, and 17 more. Categorized as 12 Core + 5 AI-Specific + 4 Quality.

**Autonomous hardening (Stage 1.5).** Run `/plan-refine` and 6 adversarial perspectives stress-test your plan without asking you a single question. The Pedantic Lawyer catches vague gates. The Devil's Advocate challenges your core assumption. You get back a hardened plan with a change log.

**Quality rubric with teeth.** Grade C/B/A based on objective criteria. Numbers need sources. Gates must be observable. Delegated work needs input/output specs. FAILED conditions must be measurable.

**Reference Library.** For coding domains, plans must link the official docs they consulted - so the person maintaining the output has the same sources.

**8 domain detection.** Software, AI/Agent, Business, Content, Infrastructure, Data & Analytics, Research, Multi-Domain. Each domain auto-includes relevant sections.

## 5-Minute Quick Start

### 1. Create a plan
```bash
/plan-new "Add OAuth login to Next.js app"
```

Claude runs through 3 stages:
- **Stage 0**: Discovers existing work, checks feasibility, challenges your approach (AHA Effect)
- **Stage 1**: Builds the plan with 5 CORE sections, domain-specific CONDITIONAL sections, and a confidence level
- **Stage 1.5**: Autonomously hardens the plan from 6 adversarial perspectives
- **Stage 2**: Meta-checks including Cold Start Test and Discovery Consolidation

### 2. Interview an existing plan
```bash
/interview-plan path/to/plan.md
```
Framework-aware questions across 3 tiers: critical gaps, domain-specific probes, quality strengthening. References anti-patterns by number.

### 3. Review plan quality
```bash
/plan-review path/to/plan.md
```
Objective assessment against the rubric. Returns grade, anti-patterns found, and top 3 improvements.

### 4. Harden a plan autonomously
```bash
/plan-refine path/to/plan.md
```
6 perspectives stress-test the plan. Fixes structural issues, flags strategic decisions for you.

## The Framework

### Stage 0: Discovery (Before Planning)

12 checks in 3 priority tiers. The agent decides which to run based on context.

| Tier | Checks |
|------|--------|
| Always | Existing Work, Feasibility, Better Alternatives (AHA Effect) |
| Usually | Factual Verification, Official Docs, ROI |
| Context-dependent | Updates, Best Practices, Deep Research, Competitive, Constraints, People Risk |

**The AHA Effect** (Check 0.9) is the single most valuable check:
- Custom CMS planned? "Strapi does 90% of it."
- 50 blog posts? "5 pillar posts + derivatives might outperform."
- Building from scratch? "This open-source project does 80%."

### Stage 1: The Plan

**5 CORE sections** (always required): Context & Why, Success Criteria (with FAILED conditions), Assumptions (with VALIDATE BY + IMPACT IF WRONG), Phases (with binary gates + review checkpoints), Verification (Automated + Manual + Ongoing Observability).

**18 CONDITIONAL sections** (domain-detected): Rollback, Risk, Post-Completion, Budget, User Validation, Legal, Security, Resume Protocol, Incremental Delivery, Delegation, Dependencies, Related Work, Timeline, Stakeholders, Reference Library, Learning & Knowledge Capture, Feedback Architecture, Completion Gate.

**Coding domains** size phases by scope (files, features, tests), not hours. Non-coding domains use time estimates as rough guides.

**Plan Confidence Level**: High / Medium / Low - assigned at plan header. Low confidence = Phase 1 must be a validation sprint.

### Stage 1.5: Autonomous Hardening (Optional)

6 adversarial perspectives stress-test the plan:

1. **Outside Observer** - Goal clarity, End State, ambiguous metrics
2. **Pessimistic Risk Assessor** - Single failure points, FAILED condition timeouts
3. **Pedantic Lawyer** - Vague gates, delegation contracts, deployment completeness
4. **Skeptical Implementer** - First blocker, unverified facts, cold start readiness
5. **The Manager** - Resume Protocol, scope realism, deadline acknowledgment
6. **Devil's Advocate** - Core assumption validity, 80/20 path, obsolescence risk

Structural fixes applied in place. Strategic decisions flagged as `[Stage 1.5 Note:]` for user review. Hardening Log appended as audit trail.

### Stage 2: Meta (7 Checks)

Delegation Strategy, Research Needs, Review Gates, Anti-Pattern Check (21), Cold Start Test, Plan Hygiene Protocol, Discovery Consolidation.

## Domain Detection

| Domain | Key Sections | Phase Sizing | Review Frequency |
|--------|-------------|-------------|-----------------|
| Software Development | Rollback, Risk, Delegation, Reference Library | Scope-based | Every 2 phases |
| Multi-Agent / AI | Risk, Delegation, Security, Reference Library | Scope-based | Every 2 phases |
| Business / Strategy | Timeline, Budget, Stakeholders, Validation | Time-based | Per milestone |
| Content / Marketing | Timeline, Validation, Legal, Feedback Architecture | Time-based | Per draft |
| Infrastructure / DevOps | Rollback, Risk, Dependencies, Reference Library | Mixed | Every phase |
| Data & Analytics | Risk, Rollback, Legal, Security, Reference Library | Mixed | Every phase |
| Research / Exploration | Incremental, Budget, Related Work, Learning | Time-based | Per finding |
| Multi-Domain | Union of matched domains | Most conservative | Most conservative |

## Quality Rubric

| Grade | Criteria |
|-------|----------|
| **C** (Viable) | All 5 CORE + 1 CONDITIONAL. No critical anti-patterns (#3, #9, #11, #20, #21). |
| **B** (Solid) | C + Stage 0 + FAILED conditions + Confidence Level + Cold Start Test. Zero anti-patterns. |
| **A** (Excellent) | B + sparring (0.7-0.9) + Review Checkpoints + Reference Library (coding) + Replanning triggers. |
| **Red Flags** | Vague criteria, no FAILED conditions, assumptions untested, numbers without sources, delegated work without specs. Fix before implementing. |

## When to Activate

**Use for:** New features, architecture changes (3+ files), multi-phase projects, anything with external dependencies.

**Skip when ALL true:** Single file, no external dependencies, <50 lines, no schema change, no user-facing change, rollback = git revert.

## Philosophy

Traditional planning: Goal - Approach - Steps - Execute - "Oh crap, we didn't consider X."

This framework inverts it: **Discovery - Constraints - Assumptions - THEN plan.**

Stage 0 is where you find out your "simple feature" touches 6 systems, the existing code does 70% of what you need, your timeline was off by 3x, and there's a legal requirement you didn't know about.

The framework is domain-agnostic. Use it for software features, business launches, content creation, data pipelines, research projects - anything that needs a plan.

## Examples

| Example | Domain | Grade | Key Features |
|---------|--------|-------|-------------|
| [Business Launch](examples/business-launch-plan.md) | Business / Strategy | A | AHA Effect saved 6 weeks, 8 sub-phases, full CONDITIONAL suite |
| [Content Creation](examples/content-creation-plan.md) | Content / Marketing | B | 11 sub-phases, code examples, Resume Protocol |
| [Software Feature](examples/software-feature-plan.md) | Software Development | B | OAuth implementation, Security section, Reference Library |
| [Infrastructure CI/CD](examples/infra-cicd-plan.md) | Infrastructure / DevOps | A | Resume Protocol, Rollback, Reference Library, Review Checkpoints |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. Key requirements:
- Example plans must pass their own anti-pattern self-audit honestly
- Use grades C/B/A only (no B+, A-, etc.)
- Coding examples must include a Reference Library

Found a gap the framework doesn't catch? [Open an issue](https://github.com/PrimeLineDirekt/universal-planning-framework/issues).

## License

MIT License - see [LICENSE](LICENSE) file.

---

**Built by [@PrimeLineAI](https://x.com/PrimeLineAI) - This is a thinking process, not a template. Adapt it to your needs.**
