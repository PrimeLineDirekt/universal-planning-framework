---
description: Create a new plan using the Universal Planning Framework
argument-hint: [description of what to plan]
model: opus
---

# Create New Plan

You are creating a plan for: `$ARGUMENTS`

Follow the Universal Planning Framework. Execute ALL stages in order. No stage may be skipped or replaced by inline text.

## STRICT READ-ONLY RULE

During `/plan-new` execution, ONLY the plan file may be edited. No other files may be created, edited, or deleted. No Bash commands that make changes. Only: Read, Grep, Glob, Explore/Plan Agents, AskUserQuestion, Skill (for interview/refine/review). Violation = abort planning.

This replaces EnterPlanMode/ExitPlanMode to avoid repeated UI previews that clutter the screen.

---

## Step 0: Planning Mode Selection

Before starting, ask the user how they want to work:

```
AskUserQuestion:
  "Wie möchtest du den Plan durcharbeiten?"
  Options:
    1. "Manuell - ich gehe jede Phase einzeln durch"
       (User steuert jede Phase, wählt selbst ob Interview self/interactive)
    2. "Autonom - du machst alles selbstständig"
       (Alle Phasen autonom, Interview im Self-Mode)
    3. "Autonom mit interaktivem Interview"
       (Alle Phasen autonom, aber Interview beantworte ICH)
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
**If mode = Autonom**: Document findings, proceed. Flag critical findings that would change approach.

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
**If mode = Autonom**: Auto-select based on domain, document selection rationale.

---

## Stage 1.5: Interview

**MANDATORY** - Run `/interview-plan` on the plan file.

**If mode = Manual**: User chooses interactive or self-interview.
**If mode = Autonom**: Run with `--self` flag (Claude answers own questions).
**If mode = Autonom mit interaktivem Interview**: Run interactively (user answers).

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
1. Delegation Strategy
2. Research Needs
3. Review Gates
4. Anti-Pattern Check (21 anti-patterns: 12 Core + 5 AI + 4 Quality)
5. Cold Start Test
6. Plan Hygiene Protocol
7. Discovery Consolidation

**CRITICAL**: Same rule - must be an actual skill invocation, not inline text.

---

## Stage 4: Output + Abschluss

Write the complete plan to a file:
- If `.claude/plans/` exists, write there
- Otherwise write to current directory

Include at the top: Quality Grade (C/B/A), Confidence Level (High/Medium/Low), date.

### Plan Summary (PFLICHT)

Present a structured summary to the user:

```markdown
## Plan Summary: {title}

**Was wird gebaut/geändert:**
- {neue Dateien mit Zweck}
- {geänderte Dateien mit Art der Änderung}

**Nutzen:**
- {konkreter Mehrwert 1}
- {konkreter Mehrwert 2}

**Phasen:**
| # | Phase | Deliverable | Gate |
|---|-------|-------------|------|
| 1 | ... | ... | ... |

**Aufwand**: {geschätzt} | **Files**: {Anzahl neu/geändert} | **LOC**: {geschätzt}
**Confidence**: {High/Medium/Low} | **Grade**: {A/B/C}
```

Then ask: "Plan fertig. Soll ich mit der Umsetzung beginnen?"

---

## Summary: Complete Phase Sequence

```
Step 0:     Planning Mode Selection (ask user: manual/autonom/autonom+interview)
Stage 0.pre: DSV (Decompose-Suspend-Validate on the task)
Stage 0:    Discovery (12 checks)
Stage 1:    The Plan (End State, 5 CORE, CONDITIONAL sections)
Stage 1.5:  Interview (/interview-plan skill - NOT inline)
Stage 2:    Hardening (/plan-refine skill - NOT inline)
Stage 3:    Review + Meta (/plan-review skill - NOT inline)
Stage 4:    Output + "Soll ich umsetzen?"
```

ALL stages are mandatory. None may be replaced by inline text or self-written notes.

---

## Stage 5: Execution Rules (bei Plan-Umsetzung)

Diese Regeln gelten wenn der Plan ausgefuehrt wird. Sie sind auch in `.claude/rules/plan-execution.md` persistent gespeichert (bewusste Duplikation fuer Zuverlaessigkeit).

### Nach JEDER Phase (PFLICHT)

**1. Code Review:**
- Nach jeder abgeschlossenen Phase MUSS ein Code Review laufen
- Nutze `superpowers:requesting-code-review` oder `superpowers:code-reviewer` Agent
- Spec Compliance Review ZUERST, dann Code Quality Review
- Keine Phase ist "done" ohne bestandenen Review

**2. Core Root Dateien pruefen (Abhaengigkeiten):**
- `knowledge/references/audit-hidden-dependencies.md` lesen - 6 Consumer Pathways pruefen
- `knowledge/architecture.md` lesen - Component Connection Pathways pruefen
- Frage: Hat diese Aenderung Auswirkungen auf andere Komponenten?
- Pruefen: edges.json, context-router.json, detection-index.json, _stats.json, SYSTEM-MAP.md, knowledge-nodes.json
- Vollstaendige Matrix: CLAUDE.md → Integration-Matrix

**3. Gate-Ergebnis dokumentieren:**
- PASS/FAIL + Evidenz (z.B. "BARD: 42/45 TOC-Eintraege = 93%")
- Scope-Aenderungen notieren
- Assumptions updaten (validiert/falsifiziert/neu)
- Token-Kosten kumulativ tracken (wenn LLM-basiert)

**4. Sub-Agents und Teams einsetzen:**
- Parallele unabhaengige Tasks → parallele Agents
- Code Review → dedizierter Review-Agent
- Exploration/Research → Explore Agent (haiku)
- Delegation Score ≥ 3 → automatisch delegieren (siehe `.claude/rules/delegation.md`)

### Plan-Completion (wenn ALLE Phasen durch sind)

**1. Verification Before Completion:**
- Kein Completion-Claim ohne frische Verifikation
- Alle Tests laufen lassen, Output lesen, DANN claimen
- Siehe `superpowers:verification-before-completion`

**2. Dormant File Scan:**
- IMMER einen Dormant File Scan durchfuehren bevor "done" deklariert wird
- Pruefen ob neue Dateien korrekt verlinkt/registriert sind
- Pruefen ob alte Dateien durch die Aenderungen verwaist sind
- Symlinks pruefen (keine Circular References)

**3. Abhaengigkeiten und Registrierung:**
Wenn neue Komponenten erstellt wurden, an allen relevanten Stellen registrieren:
- `_stats.json` - Counts aktualisiert
- `_graph/cache/context-router.json` - Keywords fuer Findbarkeit
- `.claude/detection-index.json` - Plain-text Trigger (wenn Command)
- `_graph/knowledge-nodes.json` - Entity im Graph
- `_graph/edges.json` - Beziehungen zu anderen Nodes
- `.claude/SYSTEM-MAP.md` - Komponenten-Inventar + Changelog
- `knowledge/index.md` - KB-Index (wenn Template/Pattern/Learning)

**4. Dokumentation:**
- README-Sections fuer neue Module
- API-Dokumentation fuer neue Endpoints
- Inline-Code-Dokumentation wo nicht selbsterklaerend

**5. Speicherung (Log/Memory/Kairn):**
- `_memory/projects/{project}.json` → Progress, Phase, Next Step updaten
- `kn_learn` → Signifikante Entscheidungen, Patterns, Gotchas
- `_memory/experiences/` → Neue Experiences wenn gelernt
- Handoff erstellen wenn Session endet vor Completion

**6. Replanning bei Gate-Failure:**
1. Triage - Trigger-Typ klassifizieren
2. Scope Damage - Welche Phasen betroffen? Kaskade?
3. Update in Place - `[REPLANNED: reason]` Marker, nie ueberschreiben
4. Recheck - Anti-Pattern Scan auf geaenderte Sections
5. Re-confirm Confidence - Fast immer sinkt sie
6. Resume - Ab erster ungestarteter Phase

---

## Plan-Speicherung (PFLICHT)

- Plan MUSS immer als Datei gespeichert werden, UNABHAENGIG ob Plan Mode aktiv ist
- Speicherort: `~/.claude/plans/` oder Projekt-Verzeichnis
- Kein Plan darf nur als Chat-Text existieren - bei Compaction/Session-Ende waere er verloren
- Plan-Datei am Anfang erstellen, nicht am Ende

---

## Summary: Complete Phase Sequence (aktualisiert)

```
Step 0:      Planning Mode Selection (ask user: manual/autonom/autonom+interview)
Stage 0.pre: DSV (Decompose-Suspend-Validate on the task)
Stage 0:     Discovery (12 checks)
Stage 1:     The Plan (End State, 5 CORE, CONDITIONAL sections)
Stage 1.5:   Interview (/interview-plan skill - NOT inline)
Stage 2:     Hardening (/plan-refine skill - NOT inline)
Stage 3:     Review + Meta (/plan-review skill - NOT inline)
Stage 4:     Output + Plan Summary + "Soll ich umsetzen?"
Stage 5:     Execution (Code Review/Phase, Dependencies, Sub-Agents, Dormant Files, Docs, Memory)
```

ALL stages are mandatory. None may be replaced by inline text or self-written notes.

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
- Execution Rules (Stage 5) gelten auch in `.claude/rules/plan-execution.md` (bewusste Duplikation)
