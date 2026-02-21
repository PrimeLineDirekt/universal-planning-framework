# Plan: Set Up GitHub Actions CI/CD for Monorepo

**Created**: 2026-02-21
**Quality Grade**: A
**Confidence Level**: High
**Estimated Complexity**: 6/10

---

## End State

After this plan succeeds, the monorepo has a fully automated CI/CD pipeline: every PR triggers lint + test + build for only the affected packages (not the entire repo), merges to main auto-deploy the affected services to staging, and a manual approval gate promotes staging to production. Developers get feedback within 5 minutes on PR checks, deployments complete in under 10 minutes, and rollback to previous version takes one click.

---

## Stage 0 Summary

**Checks Run**:
- **Existing Work Audit**: Found `.github/workflows/ci.yml` with a basic lint job. No deploy workflows. Package structure: `packages/api`, `packages/web`, `packages/shared`. Turborepo already configured with `turbo.json`.
- **Factual Verification**: Confirmed GitHub Actions supports path-based triggers, Turborepo has `--filter` for affected packages, and the hosting provider (Vercel for web, Railway for API) both support CLI deployments.
- **Official Docs Check**: Reviewed GitHub Actions workflow syntax (2026-02), Turborepo CI guide, Vercel CLI deploy docs, Railway CLI docs. All stable, no breaking changes pending.
- **Sparring: Feasibility**: Confirmed - path-based triggers + Turborepo filtering is a proven pattern used by Vercel's own monorepo and documented in Turborepo's official CI guide.
- **Sparring: Better Alternatives (AHA Effect)**: Considered 3 alternatives:
  1. Nx Cloud instead of Turborepo - would require migration (2+ days), marginal benefit for 3 packages. Rejected.
  2. Self-hosted runners - unnecessary complexity for current scale (<50 PRs/month). Rejected.
  3. Vercel's built-in monorepo support - handles web but not API. Would still need Railway workflow. Current approach (GitHub Actions for both) is simpler and unified.
- **Constraint Discovery**: GitHub Actions free tier: 2,000 minutes/month. Current usage: ~200 min/month. Plenty of headroom. No org-level restrictions on workflow permissions.
- **People Risk**: No approval chain needed - single developer with admin access. No review queue bottleneck.

**Checks Skipped**:
- Online Updates Scan - user confirmed latest versions
- Best Practices Research - team has CI/CD experience with GitHub Actions
- Deep Research Decision - proven approach, low uncertainty
- ROI - must-have for deployment reliability
- Competitive Landscape - internal project

**Key Discovery**: Turborepo + path filters means we can skip unchanged packages entirely. This reduces CI time from ~8 minutes (full repo) to ~3 minutes (affected only).

---

## Context & Why

Set up CI/CD for a 3-package monorepo to automate testing and deployment. Current state: manual deployments cause errors (wrong package deployed twice last month) and slow feedback (lint runs locally, no automated tests on PR). Need reliable, fast, automated pipeline before adding more packages.

---

## Success Criteria

**DONE when**:
- PR checks (lint + test + build) complete in under 5 minutes for single-package changes
- Only affected packages are checked on PR (path-based filtering verified)
- Merge to main auto-deploys affected services to staging
- Production deploy requires manual approval in GitHub Actions UI
- Rollback to previous deployment takes under 2 minutes
- All secrets stored in GitHub Actions secrets (not in code)

**NOT doing**:
- Preview deployments per PR (v2 - requires Vercel Pro)
- Slack/Discord notifications (v2)
- Performance benchmarking in CI
- E2E tests in pipeline (separate initiative)
- Self-hosted runners

**FAILED when**:
- CI takes longer than 8 minutes for any single-package PR - pipeline too slow, redesign caching
- More than 3 workflow failures in first week not caused by actual code issues - pipeline unreliable, debug before expanding
- If not complete after 2 focused sessions - scope too large, ship PR checks only (Phase 1-2) as v1

---

## Assumptions & Validation

- Turborepo `--filter` correctly identifies affected packages from git diff
  -> VALIDATE BY: Run `turbo run build --filter=...[HEAD^]` locally and verify only changed package builds
  -> IMPACT IF WRONG: Need custom script to parse `git diff --name-only` and map to packages (adds 2-3h)

- GitHub Actions path-based triggers fire correctly for monorepo subdirectories
  -> VALIDATE BY: Create test workflow with `paths: ['packages/api/**']` trigger, push change to `packages/web/`, verify it does NOT trigger
  -> IMPACT IF WRONG: Fall back to running all checks on every PR with Turborepo caching (slower but functional)

- Vercel CLI and Railway CLI both support non-interactive deployments from CI
  -> VALIDATE BY: Test `vercel deploy --prod --token $TOKEN` and `railway up --service api` in local terminal with CI-equivalent environment
  -> IMPACT IF WRONG: Use provider-specific GitHub integrations instead of CLI (less control but works)

- GitHub Actions free tier minutes are sufficient
  -> VALIDATE BY: Calculate: ~50 PRs/month x 5 min = 250 min. Plus ~30 deploys x 3 min = 90 min. Total ~340 min, well under 2,000
  -> IMPACT IF WRONG: Optimize with aggressive caching, or upgrade to Team plan ($4/user/month)

---

## Phases

### Phase 1: PR Check Workflow
**Scope**: 2 files - `.github/workflows/pr-checks.yml` (new), `turbo.json` (verify pipeline config)
**Deliverable**: Workflow that runs lint + test + build on PR, filtered to affected packages only
**Gate**: Open test PR changing only `packages/api/src/index.ts`. Workflow triggers, runs only API checks (not web), completes in under 5 minutes. Open second PR changing `packages/shared/`. Workflow runs shared + api + web (downstream dependents).
**Review**: Verify workflow YAML syntax against GitHub Actions docs. Confirm no secrets exposed in logs.

---

### Phase 2: Caching & Performance
**Scope**: 1 file - `.github/workflows/pr-checks.yml` (add caching steps)
**Deliverable**: Turborepo remote cache + node_modules cache configured. Second run of same PR is faster.
**Gate**: Push a no-op commit to existing PR. Second workflow run completes in under 2 minutes (cache hit). Verify cache key includes `package-lock.json` hash.

**Review Checkpoint (Phases 1-2)**: Review both workflows against GitHub Actions best practices. Verify: no hardcoded secrets, caching keys are deterministic, path filters are correct, Turborepo filter syntax is valid.

---

### Phase 3: Staging Deploy Workflow
**Scope**: 3 files - `.github/workflows/deploy-staging.yml` (new), `.github/workflows/deploy-production.yml` (new), GitHub repo settings (add secrets)
**Deliverable**: Merge to main triggers staging deploy for affected services. Production deploy requires manual approval via GitHub Actions environment protection rules.
**Gate**: Merge a test PR to main. Staging deploy triggers for correct service(s). Production workflow shows "waiting for approval" in Actions UI. Approve and verify production deployment succeeds.
**Review**: Verify deployment secrets are in GitHub Actions secrets (not env vars in YAML). Verify environment protection rules are configured for production.

---

### Phase 4: Rollback & Documentation
**Scope**: 2 files - `.github/workflows/rollback.yml` (new), `docs/ci-cd.md` (new)
**Deliverable**: One-click rollback workflow + documentation for the team
**Gate**: Trigger rollback workflow for API service. Previous version is deployed within 2 minutes. Documentation covers: how to read workflow status, how to trigger manual deploy, how to rollback, troubleshooting common failures.

**Review Checkpoint (Phases 3-4)**: Full review of all 4 workflow files. Security check: no tokens in logs, environment protection rules active, rollback tested. Documentation review: covers all scenarios.

---

## Verification

**Automated**:
- PR check workflow triggers on PR and completes without errors
- Path filtering correctly scopes to affected packages (test with changes in each package)
- Cache hit on second run (check workflow logs for "cache hit" message)
- Staging deploy triggers on merge to main
- Rollback workflow deploys previous version

**Manual**:
- Open PR with change in `packages/api` only - verify web checks do NOT run
- Open PR with change in `packages/shared` - verify all downstream packages are checked
- Merge to main - verify staging deployment succeeds for correct service
- Trigger production deploy - verify approval gate blocks until approved
- Trigger rollback - verify previous version is live within 2 minutes
- Review all workflow files for exposed secrets (grep for tokens, keys, passwords)

**Ongoing Observability**:
- GitHub Actions usage dashboard: monitor minutes consumed weekly (alert if >500/week)
- Failed workflow notifications via GitHub's built-in email alerts
- Monthly review: check if CI times have degraded (should stay under 5 min for single-package PRs)

---

## Rollback / Undo Strategy

**Trigger**: Deploy workflow deploys broken code to staging or production

**Steps**:
1. Trigger `rollback.yml` workflow with service name and "previous" tag (1 click in Actions UI)
2. Workflow pulls previous deployment artifact and redeploys
3. Verify service health after rollback

**For workflow changes themselves**:
1. All workflows are in git - revert the commit that broke the workflow
2. GitHub Actions picks up reverted workflow on next trigger
3. No manual cleanup needed

**Data**: No data involved - CI/CD is stateless except for GitHub Actions secrets (which are not modified by workflows)
**Duration**: Under 2 minutes for service rollback, under 5 minutes for workflow revert
**Point of No Return**: None - deployments are always reversible (both Vercel and Railway support instant rollback)

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation | Detection |
|------|-----------|--------|------------|-----------|
| Turborepo filter misses affected package | Low | High - untested code deployed | Validate with known dependency graph. Include `packages/shared` as always-run | Downstream package test fails in staging |
| GitHub Actions minutes exceeded | Low | Medium - CI stops working until next month | Current estimate: 340/2000 min. Monitor weekly | GitHub sends email at 75% and 100% usage |
| Secrets exposed in workflow logs | Low | Critical - credential leak | Use `secrets` context only, never echo. Add `--silent` flags to CLI commands | Review workflow logs after each new workflow. GitHub auto-masks known secret patterns |
| Deploy to wrong environment | Medium | High - production deployed without approval | Environment protection rules on `production`. Separate workflow files for staging vs production | Manual verification after first 3 deployments |

---

## Dependencies & Blockers

| Dependency | Type | Status | Fallback | Lead Time |
|-----------|------|--------|----------|-----------|
| Vercel CLI token | External | Available (existing account) | Use Vercel GitHub integration instead | 5 min to generate |
| Railway CLI token | External | Available (existing account) | Use Railway GitHub integration instead | 5 min to generate |
| GitHub Actions access | External | Available (repo admin) | N/A - required | Zero |
| Turborepo configured | Internal | Done (`turbo.json` exists) | Configure from scratch (+1h) | Zero |

---

## Resume Protocol

**TL;DR**: GitHub Actions CI/CD for 3-package monorepo. Turborepo filtering, path-based triggers, staging auto-deploy, production with approval gate, one-click rollback.

**Context Load Order**:
1. This plan file
2. `.github/workflows/` directory - check which workflows exist
3. `turbo.json` - verify pipeline configuration
4. GitHub repo Settings > Secrets and Environments - check what's configured

**Last Completed**: Plan created
**Next Action**: Phase 1 - PR Check Workflow
**Blockers**: None

**Update this section after each work session.**

---

## Reference Library

| Source | Version/Date | What It Informed | Link |
|--------|-------------|-----------------|------|
| GitHub Actions Workflow Syntax | Current, checked 2026-02 | Workflow YAML structure, path triggers, environment protection | https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions |
| Turborepo CI Guide | v2, checked 2026-02 | Monorepo filtering, remote caching in CI | https://turbo.build/repo/docs/guides/ci |
| Vercel CLI Reference | Current, checked 2026-02 | Non-interactive deployment commands, token auth | https://vercel.com/docs/cli |
| Railway CLI Reference | Current, checked 2026-02 | Service deployment from CI, token auth | https://docs.railway.app/reference/cli-api |
| GitHub Actions Security Hardening | Current, checked 2026-02 | Secret management, GITHUB_TOKEN permissions, environment protection | https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions |

---

## Post-Completion Plan

**Monitor (First 2 weeks)**:
- Daily: Check GitHub Actions runs for failures not caused by actual code issues
- Weekly: Review CI minutes usage (should stay well under 500/week)
- After each deploy: Verify correct service deployed to correct environment

**Maintain**:
- Monthly: Check if GitHub Actions or Turborepo have released updates affecting workflows
- Per new package: Add path filter entry to PR checks workflow, add deploy step to staging/production workflows
- Quarterly: Review and rotate deployment tokens

**If-Fails Plan**:
- If CI takes >5 min consistently: investigate cache misses, consider splitting workflows per package
- If deploy failures >3/week: add dry-run step before actual deploy, investigate root causes
- If minutes exceeded: optimize caching first, then consider self-hosted runner as last resort

---

## Stage 2: Meta Review

**Delegation Strategy**: All phases done by lead developer (security-sensitive, small scope). Phase 4 documentation could be delegated to a general-purpose agent (Sonnet, complexity 3).

**Research Needs**: Phase 1 may need GitHub Actions docs for path filter edge cases. Phase 3 needs Vercel/Railway CLI docs for exact deploy commands.

**Review Gates**: After Phase 2 (caching) - verify cache keys and performance. After Phase 4 (complete) - full security review of all workflows, end-to-end deploy test.

**Anti-Pattern Check**:
- Assumptions validated (Turborepo filter, path triggers, CLI deploy, minutes budget)
- Phases have clear scope boundaries and binary gates
- Specific success criteria (5 min PR checks, 2 min rollback)
- FAILED conditions with concrete thresholds
- Rollback strategy defined
- Review checkpoints at Phase 2 and Phase 4
- Reference Library with official docs linked
- Resume Protocol for multi-session work

**Replanning Triggers**: Return to Stage 0 if Turborepo filter doesn't work as expected (Assumption 1 fails) OR GitHub Actions path triggers misbehave (Assumption 2 fails). Ship Phase 1-2 only as v1 if Phase 3-4 blocked.

---

## Completion Gate

Before declaring this plan DONE, verify:

**Registration**:
- [ ] All workflow files committed to `.github/workflows/`
- [ ] Deploy scripts registered in `package.json` or `turbo.json`
- [ ] Environment variables documented and set in GitHub Settings

**Connections**:
- [ ] PR check workflow triggers on correct path patterns
- [ ] Staging deploy workflow references correct branch triggers
- [ ] Production deploy workflow references correct tag/release triggers

**Documentation**:
- [ ] README updated with CI/CD section (how to trigger deploys, where to find logs)
- [ ] Runbook created for deploy failures and rollback procedures
- [ ] Environment variable list documented for onboarding

**Orphan Detection**:
- [ ] No leftover test workflow files (`.yml.bak`, `.yml.disabled`)
- [ ] No unused secrets in GitHub Settings
- [ ] No stale branch protection rules conflicting with new workflows

**Consistency**:
- [ ] Same Node.js version across all workflow files
- [ ] Same Turborepo cache key pattern across all workflows
- [ ] Deploy commands match between local scripts and CI workflows

---

**Plan Status**: Ready for implementation
**Risk Level**: Low (proven tools, well-documented approaches, fully reversible)
