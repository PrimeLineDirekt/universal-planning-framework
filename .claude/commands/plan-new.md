---
description: Create a new plan using the Universal Planning Framework
argument-hint: [description of what to plan]
model: opus
---

# Create New Plan

You are creating a plan for: `$ARGUMENTS`

Follow the Universal Planning Framework. Execute ALL stages in order. No stage may be skipped or replaced by inline text.

## STRICT READ-ONLY RULE

During `/plan-new` execution, ONLY the plan file may be edited. No other files may be created, edited, or deleted. No Bash commands that make changes. Only: Read, Grep, Glob, Explore/Plan Agents, AskUserQuestion, Skill (for interview/refine/review), TodoWrite (for phase/task tracking). Violation = abort planning.

This replaces EnterPlanMode/ExitPlanMode to avoid repeated UI previews that clutter the screen.

---

## Step 0: Planning Mode Selection

Before starting, ask the user how they want to work:

```
AskUserQuestion:
  "How would you like to work through the plan?"
  Options:
    1. "Manual - I'll go through each phase step by step"
       (User controls each phase, chooses interactive or self-interview)
    2. "Autonomous - you handle everything independently"
       (All phases autonomous, interview in self-mode)
    3. "Autonomous with interactive interview"
       (All phases autonomous, but I answer the interview myself)
```

Store the selected mode and follow it through all stages.

---

## Stage 0.pre: DSV (Quick Reasoning Check)

**MANDATORY** - Before any planning, run DSV on the task itself:

1. **Decompose**: What are the 2-3 key claims in this request?
2. **Suspend**: What alternative interpretation haven't I considered?
3. **Validate**: Which claim am I least sure about? Validate that first.

If Suspend reveals a plausible alternative: raise it before proceeding.
Document DSV results in the plan file under `## DSV Pre-Check`.

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

**If mode = Manual**: Present findings to user via AskUserQuestion.
**If mode = Autonomous**: Document findings, proceed. Flag critical findings that would change approach.

---

## Stage 0.5: Vehicle Selection (silent auto-inference - runs on EVERY plan)

After Discovery, before drafting phases, run the **execution-vehicle rubric** for every phase the plan will have. The rubric is at `.claude/rules/vehicle-selection.md` when the framework was installed into the project, and in the `vehicle-selection` skill when it was installed as a plugin. Use whichever is present. This is **ALWAYS silent auto-inference** - NEVER ask the user which vehicle to use, on any plan, trivial or not (an interactive vehicle prompt is a kill criterion).

For each phase the rubric emits: (a) a **VEHICLE** (single agent / sub-agents / agent team / background session / dynamic workflow / goal-loop) from raw signals (complexity, independent-stream count, decomposition shape, reversibility), with an optional adaptive delegation score as a BOUNDED tiebreaker (single-agent<->sub-agent boundary only); (b) for multi-agent vehicles, the **model tier per stage** (strongest model for orchestration/synthesis only, mid-tier for delegated work, fast/local model for simple or bulk steps).

**Output discipline (collapse when uniform, render only deviations):**

- The most-common (vehicle, routing) pair across phases becomes the plan-level **Default Vehicle**.
- Emit ONE header line on the plan: `**Default Vehicle:** <vehicle> (<routing>)`.
- Phases matching the default render **nothing**. They inherit it silently.
- Only deviations render, as a one-line tag on that phase:
  `> Vehicle: <vehicle> - <routing> - <one-line reason>`
- A **uniform plan** shows exactly the one header line, zero per-phase rows, zero prompts. A **trivial one-phase plan** shows `Default Vehicle: Single (self)` and nothing else.
- A vehicle the rubric flags `[propose/opt-in]` (dynamic workflow) or `[ask-user]` (agent team, tmux) carries that flag verbatim as a trigger-time note for whoever executes the plan, never as a planning-time prompt. The rubric is the source of truth for which vehicles carry a flag; do not treat this line as the full list.

This step adds no interactive prompt and changes no runtime behaviour. It records the planned vehicle and tier as a plan OUTPUT, for the person or agent executing the plan to act on later.

---

## Stage 1: The Plan

After Stage 0, build the plan.

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
   - **Execution vehicle** (from Stage 0.5): every phase carries an inferred vehicle and, for multi-agent vehicles, its model routing. Render it ONLY where it deviates from the plan-level Default Vehicle. Uniform plans show just the one header line.

5. **Verification** - Split into three:
   - **Automated**: tests, CI, linters (point-in-time)
   - **Manual**: walkthroughs, reviews, user testing (point-in-time)
   - **Ongoing Observability**: production metrics, alerts, health checks

### 19 CONDITIONAL Sections (detect domain, suggest relevant ones):

Auto-include based on detected domain:
- **Software**: Rollback, Risk, Post-Completion, Execution Vehicle & Orchestration, Dependencies, Reference Library
- **AI/Agent**: Risk, Execution Vehicle & Orchestration, Security, Post-Completion, Dependencies, Reference Library
- **Business**: Timeline, Budget, Stakeholders, User Validation
- **Content**: Timeline, User Validation, Legal, Feedback Architecture
- **Infrastructure**: Rollback, Risk, Dependencies, Post-Completion, Resume Protocol, Reference Library
- **Data & Analytics**: Dependencies, Risk, Rollback, Legal, Security, Post-Completion, Reference Library
- **Research**: Incremental Delivery, Budget, Related Work, Post-Completion, Risk, Learning & Knowledge Capture

Additional sections available: Resume Protocol (>10h), Incremental Delivery (>5 phases), Related Work, Stakeholders, Security, Legal, Feedback Architecture, Learning & Knowledge Capture, Completion Gate (multi-file changes, system integration, artifact registration needed).

**Reference Library** (mandatory for Software, Data, Infrastructure with 3+ phases): List official docs and best practices consulted. Format: `[source] | [version/date] | [what it informed] | [link]`.

**If mode = Manual**: Ask user which conditional sections to include via AskUserQuestion.
**If mode = Autonomous**: Auto-select based on domain, document selection rationale.

---

## Stage 1.5: Interview

**MANDATORY** - Run `/interview-plan` on the plan file.

**If mode = Manual**: User chooses interactive or self-interview.
**If mode = Autonomous**: Run with `--self` flag (Claude answers own questions).
**If mode = Autonomous with interactive interview**: Run interactively (user answers).

The interview skill asks framework-aware questions across 3 tiers:
- Tier 1: Critical gaps (missing FAILED conditions, vague criteria, unvalidated assumptions)
- Tier 2: Domain-specific probes
- Tier 3: Quality strengthening

Apply interview findings to the plan before proceeding.

---

## Stage 2: Hardening

**MANDATORY** - Run `/plan-refine` on the plan file.

This runs 6 adversarial perspectives as a real agent, NOT inline bullet points:
1. Outside Observer
2. Pessimistic Risk Assessor
3. Pedantic Lawyer
4. Skeptical Implementer
5. The Manager
6. Devil's Advocate

The agent fixes issues in place and notes strategic concerns.

**CRITICAL**: Writing `[Stage 1.5 Note: ...] ✅` as inline text is NOT a substitute for running the actual `/plan-refine` skill. The skill must be invoked via the Skill tool.

---

## Stage 3: Review + Meta Checks

**MANDATORY** - Run `/plan-review` on the plan file.

This runs 7 meta checks as a real agent:
1. Execution Vehicle & Routing (validate Stage 0.5 vehicles + routing)
2. Research Needs
3. Review Gates
4. Anti-Pattern Check (21 anti-patterns: 12 Core + 5 AI + 4 Quality)
5. Cold Start Test
6. Plan Hygiene Protocol
7. Discovery Consolidation

**CRITICAL**: Same rule - must be an actual skill invocation, not inline text.

---

## Stage 4: Output + Finalization

### Verify Report companion (recommended for Grade B and A)

Stage 4 only DECIDES whether this plan gets a verify report. The file itself is
written at Stage 5, when the plan actually ships. If you decide yes, record it in the
plan's Verification section as a named deliverable, so whoever executes the plan sees
it in the plan rather than having to remember this decision.

A verify report is a sibling file that proves each Phase Gate passed, by pasting
evidence rather than asserting an outcome. Filename is the plan's, with `-verify`:

```
plan    .claude/plans/2026-08-24-oauth-login.md
verify  .claude/plans/2026-08-24-oauth-login-verify.md
```

Each gate is proven on three legs: what TRIGGERED the work, what EFFECT it had on
real system state, and whether the downstream CONSUMER can use the result. A leg you
cannot show is not proven, and the honest word for that is deferred, not done.

Template and full guidance: `.claude/templates/verify-report-template.md` in a project install, or `${CLAUDE_PLUGIN_ROOT}/.claude/templates/verify-report-template.md` in a plugin install. Use whichever resolves.

---


Write the complete plan to a file:
- If `.claude/plans/` exists, write there
- Otherwise write to current directory

Include at the top: Quality Grade (C/B/A), Confidence Level (High/Medium/Low), date, and the **Default Vehicle** from Stage 0.5 (for example `Default Vehicle: Single (self)` on a uniform plan, with any per-phase deviations rendered inline).

### Plan Summary (required)

Present a structured summary to the user:

````markdown
## Plan Summary: {title}

**What will be built/changed:**
- {new files with purpose}
- {changed files with type of change}

**Value:**
- {concrete benefit 1}
- {concrete benefit 2}

**Phases:**
| # | Phase | Deliverable | Gate |
|---|-------|-------------|------|
| 1 | ... | ... | ... |

**Effort**: {estimated} | **Files**: {count new/changed} | **LOC**: {estimated}
**Confidence**: {High/Medium/Low} | **Grade**: {A/B/C}
````

Then ask: "Plan complete. Should I start implementing?"

## Summary: Complete Phase Sequence

```
Step 0:      Planning Mode Selection (ask user: manual/autonomous/autonomous+interview)
Stage 0.pre: DSV (Decompose-Suspend-Validate on the task)
Stage 0:     Discovery (12 checks)
Stage 0.5:   Vehicle Selection (silent per-phase vehicle + Default Vehicle; NEVER prompts)
Stage 1:     The Plan (End State, 5 CORE, CONDITIONAL sections)
Stage 1.5:   Interview (/interview-plan skill - NOT inline)
Stage 2:     Hardening (/plan-refine skill - NOT inline)
Stage 3:     Review + Meta (/plan-review skill - NOT inline)
Stage 4:     Output + Plan Summary + "Should I implement?"
Stage 5:     Execution (Code Review/Phase, Verify Report, Dependencies, Dormant Files, Docs, Memory)
```

ALL stages are mandatory. None may be replaced by inline text or self-written notes.

---

## Stage 5: Execution Rules (during plan implementation)

These rules apply while the plan is being executed, not while it is being written.

### After EVERY Phase (required)

**1. Code Review:**
- After every completed phase, a code review MUST run
- Use `superpowers:requesting-code-review` or `superpowers:code-reviewer` agent
- Spec Compliance Review FIRST, then Code Quality Review
- No phase is "done" without a passing review

**1b. Empirical verification - does it actually WORK? (required EVERY phase):**
- A phase is NOT done on "code written" / "tests added" / "committed" alone. Run or trigger what the phase built under realistic conditions, observe the real effect, and confirm a downstream consumer can actually use it (the 3-leg proof: trigger -> effect -> consumer).
- Paste the outcome evidence into the gate result. Inferred outcomes ("should work", "the doc says so") do NOT count.
- If a leg genuinely cannot be tested yet, record it as deferred-and-untested with a reason (disclosed at Plan Completion).

**2. Check dependencies before changing shared components:**
- Does this change affect anything downstream? Name the consumers, do not assume there are none.
- Read whatever your project uses to answer that: an architecture document, a dependency map, a component inventory.
- Grep for the component's name across the repo. Every place it appears is a consumer, including the ones no document lists.

**3. Document gate result:**
- PASS or FAIL, with evidence (for example "42 of 45 entries extracted = 93%, threshold was 90%")
- Note scope changes
- Update assumptions (validated/falsified/new)
- Track cumulative token cost (if LLM-based)

**4. Use sub-agents and teams:**
- Parallel independent tasks → parallel agents
- Code review → dedicated review agent
- Exploration/Research → Explore Agent (haiku)
- Delegation Score >= 3 → auto-delegate (if your project defines its own delegation rule, follow that; this framework does not ship one)

### Plan Completion (when ALL phases are done)

**1. Verification Before Completion + final re-check:**
- No completion claim without fresh verification. Run all tests, read output, THEN claim success (`superpowers:verification-before-completion`).
- **Re-verify EVERY phase gate actually PASSED** with its evidence (not just "the work was done"). Produce an explicit final status: either "all phases DONE + verified" OR a listed set of OPEN ITEMS. Never declare done while any gate is unproven.

**1a. Verify report (if the plan named one at Stage 4):**
- Write the sibling `<plan-filename>-verify.md` now, before declaring the plan done.
- One entry per phase, each quoting the gate from the plan verbatim and pasting the trigger, the effect and the consumer evidence.
- Template: `.claude/templates/verify-report-template.md` in a project install, or `${CLAUDE_PLUGIN_ROOT}/.claude/templates/verify-report-template.md` in a plugin install.

**1b. Deferred & follow-up disclosure (required before declaring done):**
- Anything that could NOT be completed - a verification left untested, a phase only partially done, an issue found-but-unfixed - MUST be recorded as a follow-up task AND in the closeout, stating WHAT it is and WHY (a short reason: time-dependent / external-blocker / risky-no-rollback / needs-design / out-of-scope). Never silently drop it. If nothing was deferred, say so explicitly.

**2. Dormant File Scan:**
- ALWAYS run a dormant file scan before declaring "done"
- Check if new files are correctly linked/registered
- Check if old files became orphaned due to changes
- Check symlinks (no circular references)

**3. Dependencies and Registration:**
A component that exists but is registered nowhere is not connected, and nothing
will fail to tell you so. For every new component, walk the places your project
uses to find things and register it in each one. In most setups that means some
subset of:
- the index or manifest that records what exists
- whatever makes it discoverable: a router, a keyword index, a command registry
- the dependency or reference graph, if the project keeps one
- the architecture or component map humans read
- the docs index

List the ones your project actually has, then check each. Grep for an existing
sibling component and follow every place its name appears; that finds registries
a checklist would miss.

**4. Documentation:**
- README sections for new modules
- API documentation for new endpoints
- Inline code documentation where not self-explanatory

**5. Persistence:**
Whatever survives the session is what the next person or agent starts from.
- Update the project's progress or status record: current phase, next action.
- Record significant decisions, patterns and gotchas wherever your setup keeps them, whether that is a knowledge base, an ADR directory, or a plain notes file.
- Write a handoff if the session ends before the plan does.

**6. Replanning on gate failure:**
1. Triage - classify trigger type
2. Scope damage - which phases affected? Cascade?
3. Update in place - `[REPLANNED: reason]` marker, never overwrite
4. Recheck - anti-pattern scan on changed sections
5. Re-confirm confidence - almost always drops
6. Resume - from first unstarted phase

---

## Plan Storage (required)

- Plan MUST always be saved as a file, regardless of whether Plan Mode is active
- Location: `~/.claude/plans/` or project directory
- No plan may exist only as chat text - it would be lost on compaction/session end
- Create the plan file at the start, not at the end

---

## Guidelines

- Use AskUserQuestion at key decision points (mode-dependent)
- Challenge the user's first idea (AHA Effect) - is there a better approach?
- Be specific in gates and criteria - no vague "looks good" gates
- Every assumption needs VALIDATE BY + IMPACT IF WRONG
- Success criteria MUST have FAILED conditions
- For coding domains: scope-based phases, Reference Library mandatory (3+ phases)
- Review Checkpoints every 2 phases for coding domains
- 21 anti-patterns to check (not 12)
- 8 domains to detect (not 6)
- NEVER claim a stage is complete without having actually run the corresponding skill/tool
