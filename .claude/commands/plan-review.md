---
description: Check plan quality against Universal Planning Framework standards
argument-hint: [plan-file-path]
model: sonnet
---

# Plan Quality Review

Read the plan file at `$ARGUMENTS` and evaluate it against Universal Planning Framework standards.

---

## Check Process

### 1. CORE Sections Check

Verify all 5 CORE sections are present, complete, and compliant:

**Context & Why:**
- Clear in max 3 sentences? Explains WHY, not just WHAT?
- Would someone unfamiliar understand in 60 seconds?

**Success Criteria:**
- Measurable, specific outcomes (not "improve" or "better")?
- NOT-scope explicitly defined?
- FAILED conditions present (kill criteria + timeout)? If missing: Red Flag.

**Assumptions & Validation:**
- Triple format? `[assumption] -> VALIDATE BY: [method] -> IMPACT IF WRONG: [consequence]`
- At least 2 assumptions? Empty = Red Flag.

**Phases:**
- Coding domains: scope-based sizing (files, features, tests)? Non-coding: time estimates OK.
- Binary gates (pass/fail, verifiable - not "code complete" or "looks good")?
- Review Checkpoints present (every 2 phases for coding, per milestone for non-coding)?

**Verification:**
- Split into 3 sub-sections: Automated + Manual + Ongoing Observability?
- If Automated empty: why can't this be tested?
- If Manual empty: user-facing aspect ignored?
- If Ongoing Observability empty: how do we know it keeps working?

### 2. End State & Confidence Check

- **End State**: Is there a paragraph describing the concrete outcome? (Recommended, not required)
- **Confidence Level**: High / Medium / Low assigned at plan header?
  - Low confidence = Phase 1 must be validation sprint

### 3. Domain Detection (8 domains)

Determine which domain(s) apply:
- **Software Development** - APIs, code, databases, systems
- **Multi-Agent / AI System** - agents, orchestration, LLM pipelines
- **Business / Strategy** - process, growth, market, revenue
- **Content / Marketing** - campaigns, content, audience, SEO
- **Infrastructure / DevOps** - CI/CD, servers, monitoring, infrastructure
- **Data & Analytics** - pipelines, dashboards, data contracts
- **Research / Exploration** - investigations, experiments, decision-making
- **Multi-Domain** - if 2+ domains apply, use union

### 4. CONDITIONAL Sections Check

Based on detected domain, verify relevant sections are present:

**Software Development:** Dependencies, Risk, Rollback, Post-Completion, Delegation, Reference Library
**Multi-Agent / AI:** Dependencies, Risk, Delegation, Security, Post-Completion, Reference Library
**Business / Strategy:** Timeline, Budget, Stakeholders, User Validation
**Content / Marketing:** Timeline, User Validation, Legal, Feedback Architecture
**Infrastructure / DevOps:** Dependencies, Risk, Rollback, Post-Completion, Resume Protocol, Reference Library
**Data & Analytics:** Dependencies, Risk, Rollback, Legal, Security, Post-Completion, Reference Library
**Research / Exploration:** Incremental Delivery, Budget, Related Work, Post-Completion, Risk, Learning & Knowledge Capture
**Multi-Domain:** Union of all sections from matched domains

**Additionally check:**
- >10h effort -> Resume Protocol present?
- >5 phases or >20h -> Incremental Delivery present?
- Coding domain with 3+ phases -> Reference Library present?
- Coding domain -> Review Checkpoints in phases?
- Multi-file plan with artifact registration -> Completion Gate present?

### 5. Anti-Pattern Scan (21 total)

**Core (1-12):**

| # | Anti-Pattern | Detection |
|---|-------------|-----------|
| 1 | Unvalidated Assumptions | Entries without VALIDATE BY |
| 2 | All-or-Nothing Phases | Unclear scope boundaries or no testable checkpoint |
| 3 | Vague Success | "improve", "better", "enhance" without metrics |
| 4 | No Rollback | Irreversible changes without Rollback section |
| 5 | Plan Ends at Deploy | Last phase is Deploy/Submit, nothing after |
| 6 | No Resume Protocol | >10h effort without Resume section |
| 7 | Parallel Without Contracts | Delegation without interface definitions |
| 8 | Blind Delegation Trust | No verification after delegation |
| 9 | Skipping Stage 0 | No discovery evidence on complex plan |
| 10 | First Idea = Final | No alternatives considered |
| 11 | Zombie Project | No FAILED conditions, no timeout |
| 12 | Timeline Fantasy | Zero buffer or round-number estimates |

**AI-Specific (13-17):**

| # | Anti-Pattern | Detection |
|---|-------------|-----------|
| 13 | Confidence Without Evidence | Assertions without validation source |
| 14 | Wrong Level of Detail | Over-detailed in wrong places, vague in critical ones |
| 15 | Premature Precision | Numbers without citation/baseline |
| 16 | Hallucinated Effort Estimate | AI work estimated without iteration cycles |
| 17 | Delegation Without Context Transfer | Agents named but input not specified |

**Quality (18-21):**

| # | Anti-Pattern | Detection |
|---|-------------|-----------|
| 18 | Unverifiable Gates | Judgment words in gates ("good", "acceptable") |
| 19 | Missing Tool Fallback | Assumes tool availability without fallback |
| 20 | Discovery Amnesia | Plan references fewer findings than Stage 0 produced |
| 21 | Assumed Facts | Statements assert facts without source |

### 6. Stage 0 Evidence Check

- Existing work checked (0.1)?
- Feasibility questioned (0.7)?
- Alternatives considered - AHA Effect (0.9)?
- Constraint Discovery done (0.11)?
- For coding domains: Official Docs consulted (0.3)?
- If complex plan and no Stage 0 evidence: flag anti-pattern #9

### 7. Semantic Quality Checks

- Numbers have sources (not fabricated)?
- FAILED conditions are measurable (not judgment)?
- Gates reference observable outputs?
- Delegated work has input/output specs?
- Facts are cited or marked as assumptions?

### 8. Cold Start Test

Could a fresh agent execute this plan with ONLY this document? No oral history, no tribal knowledge? If not: what's missing?

### 9. Discovery Consolidation

If Stage 0 section exists: does every finding appear in the plan (addressed or dismissed)? Flag anti-pattern #20 if findings are orphaned.

### 10. Quality Scoring

**Grade C (Viable):**
- All 5 CORE sections present + 1 CONDITIONAL
- No critical anti-patterns (#3, #9, #11, #20, #21)

**Grade B (Solid):**
- C + Stage 0 done + FAILED conditions + Confidence Level + Constraint Discovery (0.11)
- Cold Start Test passes
- Zero anti-patterns across all 21

**Grade A (Excellent):**
- B + sparring (0.7-0.9) + People Risk (0.12)
- Review Checkpoints in phases
- Reference Library (coding domains)
- Learning & Knowledge Capture (multi-session)
- Replanning triggers defined

**Red Flags (must fix before implementation):**
- Missing or vague Success Criteria
- No FAILED conditions
- Empty Assumptions section
- Phases without verifiable gates
- Numbers without sources
- FAILED conditions not measurable
- Delegated work without input/output specs

---

## Report Format

```markdown
# Plan Review Report

**Plan:** [filename] | **Domain:** [detected] | **Grade:** [C/B/A] | **Confidence:** [H/M/L]
**Recommendation:** [Proceed / Fix then proceed / Interview first / Replan]

## CORE Sections

| Section | Status | Format | Issue |
|---------|--------|-----------|-------|
| Context & Why | ok/warn/missing | Yes/No | [specific issue or "-"] |
| Success Criteria | ok/warn/missing | Yes/No | [FAILED conditions?] |
| Assumptions | ok/warn/missing | Yes/No | [Triple format?] |
| Phases | ok/warn/missing | Yes/No | [Binary gates? Review checkpoints?] |
| Verification | ok/warn/missing | Yes/No | [Auto + Manual + Observability split?] |

## CONDITIONAL Sections

Based on [domain] domain:

| Section | Status | Notes |
|---------|--------|-------|
| [section] | present/missing/N/A | [notes] |

## Stage 0 Evidence

- Existing work checked: [yes/no/unclear]
- Feasibility questioned: [yes/no/unclear]
- Alternatives considered: [yes/no/unclear]
- Constraints discovered: [yes/no/unclear]
- Official docs consulted: [yes/no/unclear/N/A]
- Stage 0 status: [Done / Partial / Skipped]

## Anti-Patterns Found

- **#[N] [Name]**: [specific example from plan]
  -> Fix: [concrete action]

## Review Checkpoints

[Present with correct cadence / Present but wrong cadence / Missing]

## Reference Library

[Present with sources / Present but incomplete / Missing (required for domain) / N/A]

## Red Flags

- [Issue]: [why this blocks implementation + how to fix]

## Top 3 Improvements

1. [Highest impact: specific action with example]
2. [Next: specific action]
3. [Next: specific action]

## Bottom Line

[1-2 sentences: grade, what's strong, what must be fixed, recommendation]
```

---

## Replanning Recommendation

If the review reveals:
- 3+ Red Flags, or Grade below C, or multiple CORE sections missing
-> Recommend `/interview-plan` first or returning to Stage 0.

---

## Guidelines

- **Be specific**: Quote problematic text. Not "Success Criteria weak" but "uses 'improve performance' - suggest: 'p95 < 200ms'."
- **Check format**: Section exists is not enough - check if it follows the framework format (triple assumptions, binary gates, verification split, FAILED conditions).
- **Be actionable**: Every issue needs a concrete fix.
- **Be concise**: Report, not essay. Tables and bullets.
- **Check all 21 anti-patterns**: 12 Core + 5 AI-Specific + 4 Quality.
- **Check 8 domains**: Software, AI/Agent, Business, Content, Infrastructure, Data, Research, Multi-Domain.

## Usage

```bash
/plan-review path/to/plan.md
```
