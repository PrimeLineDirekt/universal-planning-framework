# Changelog

All notable changes to the Universal Planning Framework are documented here.

## [1.1.0] - 2026-02-21

### Added
- **Completion Gate** - new CONDITIONAL section (18th) for verifying artifacts are registered, connected, documented, and consistent before marking a plan DONE. Defined during plan creation, executed at plan completion.
- Domain-specific Completion Gate checks for all 8 domains

### Changed
- Version numbering: 2.0 renamed to 1.1 (semantic versioning aligned with actual maturity)
- CONDITIONAL sections expanded from 17 to 18
- Removed "v3" version references from all operational files (commands, agents). Only the rule file carries the version.

### Fixed
- `content-creation-plan.md`: Added missing Confidence Level
- All 3 non-infra examples: Added missing Ongoing Observability sub-section to Verification
- `software-feature-plan.md`: Added missing Post-Completion Plan section (domain-required for Software)
- `business-launch-plan.md`: Expanded Stage 2 anti-pattern audit from 9 to 16 entries (covering all 21 anti-patterns)
- Deleted 7 orphan research files and 1 orphan routing log

## [1.0.1] - 2026-02-21

### Added
- **Stage 1.5: Autonomous Hardening** - 6 adversarial perspectives stress-test plans without human input
- **`/plan-refine` command** - invoke Stage 1.5 standalone (simple mode + experimental team mode)
- **9 new anti-patterns** (#13-#21): Confidence Without Evidence, Wrong Level of Detail, Premature Precision, Hallucinated Effort Estimate, Delegation Without Context Transfer, Unverifiable Gates, Missing Tool Fallback, Discovery Amnesia, Assumed Facts
- **2 new Stage 0 checks**: 0.11 Constraint Discovery, 0.12 People Risk
- **3 new CONDITIONAL sections**: Reference Library, Learning & Knowledge Capture, Feedback Architecture
- **2 new domains**: Data & Analytics, Research / Exploration (total: 8)
- **Plan Confidence Level** (High/Medium/Low) at plan header
- **Replanning Protocol** - 6 concrete steps replacing trigger list
- **Verification split** into 3 sub-sections: Automated, Manual, Ongoing Observability
- **Review Checkpoints** embedded in phases (every 2 phases for coding domains)
- **End State** recommended paragraph in Stage 1
- **Scope-based phase sizing** for coding domains (instead of time estimates)
- **Phase template** for coding domains (Scope, Deliverable, Gate, Review)
- **Cold Start Test** in Stage 2 meta checks
- **Discovery Consolidation Check** in Stage 2
- **Plan Hygiene Protocol** in Stage 2
- **Semantic quality checks** in Quality Rubric
- **`/interview-plan --self` flag** for self-interview mode
- **Framework-aware interview questions** referencing anti-patterns by number
- **4th example**: Infrastructure/DevOps CI/CD plan
- **Reference Library** mandatory for coding domains with 3+ phases
- CONTRIBUTING.md, CHANGELOG.md, issue templates

### Changed
- Anti-pattern #2 detection: "any phase >4h" changed to "unclear scope boundaries or no testable intermediate checkpoint"
- Stage 0 check 0.3 (Official Docs) elevated to Always tier for coding domains
- Stage 0 skip criteria: added "AND changes are fully reversible"
- Quality Rubric updated: Grade C now checks #20 and #21, Grade B requires Confidence Level and Cold Start Test, Grade A requires Review Checkpoints and Reference Library
- Stage 2 expanded from 4 to 7 meta checks
- Quick Reference updated with all new concepts
- Domain Detection expanded from 6 to 8 domains with review checkpoint frequencies
- CONDITIONAL sections expanded from 14 to 17
- `/plan-new` command: adds Stage 1.5 inline, 12 checks, 8 domains, Reference Library enforcement
- `/interview-plan` command: framework-aware questions, 3 tiers, --self flag, ~85 lines (was ~41)
- `/plan-review` command: 21 anti-patterns, 8 domains, canonical report format, semantic checks
- `planner` agent: matching canonical report format, all V2 checks
- All example plans: split oversized phases, honest self-audits, fixed grades (no B+/A-)

### Fixed
- `planner.md` frontmatter: `name: plan-reviewer` corrected to `name: planner`
- `plan-review.md` usage section: `/plan-quality-check` corrected to `/plan-review`
- Example self-audits: removed "mostly" rationalizations
- Business launch example: Grade A- corrected to A (now earns it with phase splits + Resume Protocol)
- Software feature example: Grade B+ corrected to B

## [1.0.0] - 2026-02-13

### Added
- Initial release: 3-stage framework (Stage 0, Stage 1, Stage 2)
- 10 Stage 0 discovery checks with priority tiers
- 5 CORE sections with format requirements
- 14 CONDITIONAL sections
- 12 anti-patterns with detection rules and fixes
- Quality Rubric (C/B/A grading)
- Domain Detection (6 domains)
- 3 example plans (Business Launch, Content Creation, Software Feature)
- `/plan-new`, `/interview-plan`, `/plan-review` commands
- `planner` agent
- Quick Reference card
