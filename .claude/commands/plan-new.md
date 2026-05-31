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

After Discovery, before drafting phases, run the **execution-vehicle rubric** (`.claude/rules/vehicle-selection.md`) for every phase the plan will have. This is **ALWAYS silent auto-inference** - NEVER ask the user which vehicle to use, on any plan, trivial or not (an interactive vehicle prompt is a kill criterion).

For each phase the rubric emits: (a) a **VEHICLE** (single agent / sub-agents / agent team / background session / dynamic workflow / goal-loop) from raw signals (complexity, independent-stream count, decomposition shape, reversibility), with an optional adaptive delegation score as a BOUNDED tiebreaker (single-agent<->sub-agent boundary only); (b) for multi-agent vehicles, the **model tier per stage** (strongest model for orchestration/synthesis only, mid-tier for delegated work, fast/local model for simple or bulk steps).

**Output discipline (collapse-when-uniform):** the most-common (vehicle, routing) across phases becomes the plan-level `Default Vehicle` header line; phases matching it render nothing; only deviations render a one-line tag. A uniform plan shows one line, a trivial 1-phase plan shows `Default Vehicle: Single (self)` - both with zero prompts. Vehicles flagged propose/opt-in (dynamic workflow) or ask-user (agent team, tmux) carry that flag as a trigger-time note, never a planning-time prompt.

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

Write the complete plan to a file:
- If `.claude/plans/` exists, write there
- Otherwise write to current directory

Include at the top: Quality Grade (C/B/A), Confidence Level (High/Medium/Low), date.

### Plan Summary (required)

Present a structured summary to the user:

```markdown
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
```

Then ask: "Plan complete. Should I start implementing?"

---

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
Stage 5:     Execution (Code Review/Phase, Dependencies, Sub-Agents, Dormant Files, Docs, Memory)
```

ALL stages are mandatory. None may be replaced by inline text or self-written notes.

---

## Stage 5: Execution Rules (during plan implementation)

These rules apply when the plan is being executed. They are also persistently stored in `knowledge/rules/workflow/plan-execution.md` (intentional duplication for reliability).

### After EVERY Phase (required)

**1. Code Review:**
- After every completed phase, a code review MUST run
- Use `superpowers:requesting-code-review` or `superpowers:code-reviewer` agent
- Spec Compliance Review FIRST, then Code Quality Review
- No phase is "done" without a passing review

**2. Check core root files (dependencies):**
- Read `knowledge/references/audit-hidden-dependencies.md` - check 6 Consumer Pathways
- Read `knowledge/architecture.md` - check Component Connection Pathways
- Question: Does this change affect other components?
- Check: edges.json, context-router.json, detection-index.json, _stats.json, SYSTEM-MAP.md, knowledge-nodes.json
- Full matrix: CLAUDE.md → Integration Matrix

**3. Document gate result:**
- PASS/FAIL + evidence (e.g. "BARD: 42/45 TOC entries = 93%")
- Note scope changes
- Update assumptions (validated/falsified/new)
- Track cumulative token cost (if LLM-based)

**4. Use sub-agents and teams:**
- Parallel independent tasks → parallel agents
- Code review → dedicated review agent
- Exploration/Research → Explore Agent (haiku)
- Delegation Score >= 3 → auto-delegate (see `.claude/rules/delegation.md`)

### Plan Completion (when ALL phases are done)

**1. Verification Before Completion:**
- No completion claim without fresh verification
- Run all tests, read output, THEN claim success
- See `superpowers:verification-before-completion`

**2. Dormant File Scan:**
- ALWAYS run a dormant file scan before declaring "done"
- Check if new files are correctly linked/registered
- Check if old files became orphaned due to changes
- Check symlinks (no circular references)

**3. Dependencies and Registration:**
When new components are created, register them at all relevant locations:
- `_stats.json` - update counts
- `_graph/cache/context-router.json` - keywords for discoverability
- `.claude/detection-index.json` - plain-text triggers (if command)
- `_graph/knowledge-nodes.json` - entity in graph
- `_graph/edges.json` - relationships to other nodes
- `.claude/SYSTEM-MAP.md` - component inventory + changelog
- `knowledge/index.md` - KB index (if template/pattern/learning)

**4. Documentation:**
- README sections for new modules
- API documentation for new endpoints
- Inline code documentation where not self-explanatory

**5. Persistence (Log/Memory/Kairn):**
- `_memory/projects/{project}.json` → update progress, phase, next step
- `kn_learn` → significant decisions, patterns, gotchas
- `_memory/experiences/` → new experiences if learned
- Create handoff if session ends before completion

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
- Execution Rules (Stage 5) are also in `knowledge/rules/workflow/plan-execution.md` (intentional duplication)
