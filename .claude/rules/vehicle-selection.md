# Vehicle Selection (UPF Execution-Vehicle Rubric)

**Version:** 1.0
**Category:** planning, orchestration, meta-cognition
**Tags:** vehicle, execution, delegation, model-routing, workflow, goal-mode

---

## Purpose

For **every phase of every plan**, emit the optimal **execution vehicle** plus **per-stage model routing** as a planning OUTPUT. Selection is **ALWAYS silent auto-inference** - there is NO interactive vehicle-selection prompt, on any plan, trivial or not (kill criterion if violated). This rubric runs at planning time only; quick ad-hoc runs you trigger yourself are NOT gated by it.

This rubric is **planning prose** - a deterministic decision procedure the planner runs inline. It adds no runtime hook; it only records a decision into the plan for you (or your agents) to act on.

---

## The 6 Vehicles (+ 1 escalation-beyond)

| Vehicle | Claude Code mechanism | Engage when (raw signals) | Notes |
|---|---|---|---|
| **Single** | main agent, no delegation | complexity <=2 AND 1 stream AND trivial decomposition; OR the user must see it; OR a critical/destructive/irreversible step | Default for trivial plans (silent). |
| **Sub-Agent** | Task tool (1-N parallel subagents) | complexity 3-6, 1-3 independent units, isolated context protects the main thread | The workhorse. N parallel = independent streams with NO inter-agent comms. |
| **Agent-Team** | `team_name` + SendMessage | 3+ **interdependent** streams that genuinely need inter-agent real-time comms | Rarely the best fit in practice - parallel Sub-Agents usually cover independent work better. Bias against; treat as ask-user; never silent-default. |
| **Agent-View** | background sessions (`claude --bg`/`--resume`/pinned) + agents dashboard | long-running work that needs monitoring/pinning/ambient observation | Rare inside a single plan's phases. |
| **Dynamic-Workflow** | Workflow tool (a JS script orchestrating many subagents, fan-out + adversarial-verify) | codebase-wide audit; large (100+ file) migration; cross-checked research; multi-angle design; discovery that loops until dry | Opt-in / propose (spawns many agents). Never auto-launch. |
| **Goal-loop** | `/goal` or a loop-until-done helper | work-until-a-completion-condition; unknown iteration count | One evolving target iterated until a condition is met. |

**Escalation-beyond-the-6 (coexists, not one of the 6):** **tmux orchestration** (full Claude Code sessions, one per worker) when a phase exceeds the subagent turn/context ceiling OR each worker needs its own full context / tools / a manual review-gate. Point here when Sub-Agent/Workflow ceilings are exceeded. Always ask-user.

---

## Inputs (HYBRID model: raw signals PRIMARY, an optional adaptive score TIEBREAKER only)

### Raw signals (PRIMARY - drive the vehicle)
Per phase, the planner reads these off the phase scope (no agent pass needed):
- **complexity** (1-10): how hard is the reasoning/work in this phase?
- **independent_streams** (int): how many units of work could run in parallel with no shared state?
- **interdependent** (bool): do those streams need to talk to each other mid-run?
- **decomposition_known** (bool): is the work-list knowable up front, or discovery-shaped?
- **bulk** (bool): >10 homogeneous items / mechanical transform?
- **tool_use_required** (bool): does the work need tools (vs pure text transform)?
- **reversible** (bool): revert-able / no destructive external effect?
- **keywords**: `critical`/`destructive` (production, deploy, secret, `rm -rf`, drop database), `user-must-see`, `audit`/`codebase-wide`, `migration`/`100+ files`, `cross-checked research`, `multi-angle`, `loop-until`/`work-until-condition`.

### Optional adaptive delegation score (TIEBREAKER ONLY - tightly bounded)
If your setup tracks an adaptive "should I delegate?" score (optional - many setups do not), use it ONLY as a tiebreaker, and ONLY when the raw signals place the phase inside the **Single<->Sub-Agent tiebreaker band**:
> `complexity in [2,4]` **AND** `independent_streams == 1` **AND** no structural signal fired (no audit/migration/research/multi-angle/loop-until/long-running/3+-interdependent).

Inside the band: score above threshold -> **Sub-Agent**, else **Single**.

**Why bounded:** an adaptive/self-tuning score can drift over time. Capping it to this single boundary means drift can only ever nudge the Single<->Sub-Agent decision - it can NEVER over-escalate to a heavy vehicle (Agent-Team, Workflow, Goal-loop, tmux), because those require structural signals a drift-prone scalar must not override. If you have no such score, default to **Single** inside the band (conservative).

---

## Decision procedure (deterministic, cheap, inline)

Run per phase, top to bottom; first match wins.

```
STEP A - HARD GATES (override everything):
  A1. critical/destructive keyword OR user-must-see
      OR irreversible external side-effect (reversible=false: live
      send / external-create / prod-write, even with no destructive
      keyword)                                                     -> Single [+ ask-user if irreversible]
  A2. work-until-condition / unknown iterations on a SINGLE-THREADED
      target (refine-one-thing-until-done; NOT a multi-item
      discovery fan-out -> that is B1)                            -> Goal-loop

STEP B - STRUCTURAL VEHICLE (raw signals, PRIMARY):
  B1. codebase-wide audit OR 100+ file migration OR cross-checked
      research OR multi-angle design OR discovery-shaped enumeration
      / repeated fan-out rounds across MANY items
      (decomposition_known=false AND multi-item)                 -> Dynamic-Workflow  [propose/opt-in]
  B2. exceeds subagent turn/context ceiling OR per-worker needs full
      context / tools / compaction                               -> tmux orchestration [ask-user]
  B3. long-running AND needs monitoring/pinning/ambient          -> Agent-View
  B4. 3+ streams AND interdependent (need inter-agent comms)     -> Agent-Team        [ask-user; else parallel Sub-Agents]
  B5. 2+ independent streams (no inter-agent comms) AND
      AT LEAST ONE stream is NON-TRIVIAL (per-stream complexity>=3
      OR a large independent rewrite) AND streams do NOT
      cross-reference each other  (route per-stream at that
      stream's own complexity tier)                              -> Sub-Agent (N parallel)
  B6. complexity 3-6 AND independent_streams<=1 AND NOT trivial-
      per-B7  (binary; "isolated context" is rationale, not a gate) -> Sub-Agent
  B7. (independent_streams<=1 AND complexity<=2 AND trivial decomp);
      OR (multiple streams that are EACH trivial, per-stream cx<=2);
      OR (multiple streams that cross-reference each other -
          coherence needs one pass)                              -> Single

STEP C - TIEBREAKER (bounded; reached ONLY when NO A/B rule fired -
         in practice the single-stream borderline: independent_streams==1
         AND complexity==2 AND decomposition NOT trivial AND no
         structural signal):
  C1. if an adaptive delegation score exists and is above threshold
      -> Sub-Agent ; else -> Single
  (Hard cap: C can ONLY emit Single or Sub-Agent. It can NEVER reach
   Agent-Team / Agent-View / Dynamic-Workflow / Goal-loop / tmux.
   No score available -> default Single.)
```

> **Sub-Agent (N parallel) vs Dynamic-Workflow - crisp boundary (resolves the B5/B1 debate):** if the work-list is **KNOWN and bounded** (you can name the N items now) AND results just merge at the end -> **Sub-Agent (N parallel)**. If the work is **discovery-shaped** (unknown count, needs repeated fan-out rounds / loop-until-dry) OR each finding needs **adversarial cross-verification** before trust -> **Dynamic-Workflow**. (So 5 named dispatches = Sub-Agent; "find all the bugs, verify each" = Workflow.)

> **Coverage note (no fall-through):** B-rules are evaluated top-down, first-match-wins, and partition the space: A1/A2 hard gates; B1-B4 structural (audit/scale/long-running/interdependent); B5 multi-stream-with-real-work; B6 single-stream cx3-6; B7 the trivial floor (single-stream-trivial OR all-trivial-multi OR cross-referencing-multi); C the single-stream cx2-non-trivial-decomp borderline. A mixed 2-stream phase (one cx>=3, one cx<=2, independent, non-cross-referencing) matches B5 via "at least one non-trivial". No phase falls through.

Then attach **model routing** to the chosen vehicle (next section). Single also gets a routing tag (the self-tier) so the plan is uniform-shaped.

---

## Model routing (per stage/agent)

For multi-agent vehicles (Sub-Agent N-parallel, Agent-Team, Dynamic-Workflow, tmux) specify the model **per stage/agent**. For Single, tag the self-tier. Decision per stage, first match wins:

```
M1. stage kept on SELF / not delegated (very high complexity -> "don't
    delegate, stay on the strongest model"), OR the orchestrator /
    synthesis stage of a multi-agent vehicle              -> strongest model (self / orchestrator)
M2. bulk / mechanical transform (>10 homogeneous items, no tool-use,
    not quality-critical: bulk text-transform, large JSON-extract,
    bulk rewrite, summarize/translate)                    -> a fast or locally-hosted small model
M3. delegated implement / review / research / debug /
    architecture / security work, mid complexity          -> mid-tier model
M4. quick search / file-discovery / simple docs, low complexity -> fastest model
```

> **Strongest-model vs mid-tier boundary:** keep the strongest model for the non-delegated main reasoning or a workflow's orchestration/synthesis stage only. Delegated work - even hard, high-effort delegated work - should run on a mid-tier model; a delegated stage is rarely worth the strongest (and slowest/most expensive) tier. Treat your model tiers as a human-decided convention, not something to auto-tune away.

The bulk/local-model route (M2) only applies when the work is genuinely mechanical AND tool-free AND not quality-critical; if any of those fail, fall through to the mid-tier model.

---

## Output shape (per-phase data model + plan-level default; collapse-when-uniform)

The plan carries a per-phase vehicle field (data model). DISPLAY collapses:

1. Compute vehicle + routing for **every** phase.
2. The most common (vehicle, routing) across phases = the **plan-level Default Vehicle**.
3. Emit ONE plan-header line: `**Default Vehicle:** <vehicle> (<routing>)`.
4. Phases that match the default render **nothing** (silent inheritance).
5. Only **deviations** render, as a one-line tag on that phase: `> Vehicle: <vehicle> - <model-routing block> - <1-line reason>`.
6. **Uniform plan** (all phases identical) collapses to exactly the single `Default Vehicle:` line, zero per-phase rows, zero prompts. If the default vehicle is flagged `[propose/opt-in]` (Dynamic-Workflow) or `[ask-user]` (Agent-Team, tmux), carry the flag into the Default Vehicle line verbatim - the flag is a trigger-time NOTE, still NOT a planning-time prompt.
7. **Trivial 1-phase plan** -> `Default Vehicle: Single (self)`, nothing else. Silent.

No interactive prompt is ever emitted by this step. Vehicles flagged `[propose/opt-in]` or `[ask-user]` record that flag as a NOTE for the human at trigger time - they do NOT prompt during planning.

---

## Concrete mismatch signals (so the rubric stays falsifiable + self-correctable)

Retrospective wrong-fit signals worth logging:
- **over-vehicled**: a Workflow/Team was chosen but <3 agents actually ran, or only 1 stage had real work.
- **under-vehicled**: Single/Sub-Agent was chosen but manual fan-out was needed mid-task.
- **mis-routed**: a bulk/transform stage that a fast or local model could have handled ran on the strongest (most expensive) model.

If your setup does not yet capture per-run agent counts, track these manually for the first weeks, then revisit the rubric.

---

## Worked micro-examples

- *1-file regression fix* (cx 2, 1 stream, trivial): B7 -> **Single (self)**. Uniform 1-phase -> one Default line, silent.
- *Build a 4-module pipeline, sequential deps* (cx 6, 1 stream): B6 -> **Sub-Agent (mid-tier)** per phase.
- *5 independent research tracks + synthesis*: B1 (cross-checked research / multi-angle) -> **Dynamic-Workflow** [propose], stages mid-tier, synthesis strongest model.
- *Bulk rewrite 200 strings, mechanical* (cx 3, bulk, no tool-use): vehicle B6 Sub-Agent; routing M2 -> **fast/local model**.
- *Codebase-wide audit, 8 dimensions*: B1 -> **Dynamic-Workflow** [propose], dimension agents mid-tier, verify mid-tier, synthesis strongest.
- *loop until 10 bugs found*: A2 -> **Goal-loop**.

---

## Anti-drift + safety invariants

1. Selection is ALWAYS silent. Any interactive vehicle prompt = kill criterion.
2. The adaptive-score tiebreaker touches ONLY the Single<->Sub-Agent line. Hard-capped.
3. Model tiers are a human-decided convention - do not auto-tune them.
4. Agent-Team is biased-against: ask-user, never silent-default; default fallback is parallel Sub-Agents.
5. Dynamic-Workflow + tmux + Agent-Team are propose/ask-user at trigger time, never auto-launched, never prompted during planning.
6. This rubric is planning-layer only - no runtime hook required.
