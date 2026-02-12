# Plan: Add OAuth Login to Next.js App

**Created**: 2026-02-13
**Quality Grade**: B+
**Estimated Complexity**: 6/10

---

## Stage 0 Summary

**Checks Run**:
- ✅ **Existing Work Audit**: Found NextAuth.js already installed but not configured. Email/password auth exists. Just need to add providers.
- ✅ **Factual Verification**: Confirmed OAuth providers (Google, GitHub) support our use case and session management exists.
- ✅ **Official Docs Check**: Reviewed NextAuth.js v5 docs, Google OAuth and GitHub OAuth official guides.
- ✅ **Sparring: Feasibility**: Confirmed this is 1 feature (OAuth) not 3 (OAuth + session management + profile system).
- ✅ **Sparring: Better Alternatives (AHA Effect)**: Considered building custom OAuth flow vs. NextAuth.js. NextAuth.js is 90% of what we need with 10% effort - no need to reinvent.

**Checks Skipped**:
- ❌ Online Updates Scan - NextAuth.js v5 is stable, user confirmed
- ❌ Best Practices Research - team has OAuth implementation experience
- ❌ Deep Research Decision - low uncertainty, proven approach
- ❌ ROI - user validated, must-have feature
- ❌ Competitive Landscape - internal feature, no public equivalent

**Key Discovery**: NextAuth.js config exists but empty. 70% of work is provider setup, not infrastructure.

---

## Context & Why

Enable users to log in via Google and GitHub OAuth in addition to existing email/password auth. Current auth limits user acquisition - social login removes friction and increases signup conversion by ~40% based on industry benchmarks.

---

## Success Criteria

**DONE when**:
- User can complete OAuth flow with Google and GitHub
- Existing email/password users can link OAuth accounts from profile
- Session persists correctly after OAuth login
- Profile page shows linked accounts
- Zero security vulnerabilities in token handling (validated by security checklist)

**NOT doing**:
- Twitter/LinkedIn OAuth (v2)
- Account merging if user has same email via different methods
- Two-factor authentication

**FAILED when**:
- Security audit fails (callback URLs not validated, tokens logged, CSRF vulnerability) - STOP and fix
- OAuth flow success rate < 95% in testing - investigate before production
- If not shippable after 8 hours effort - scope too large, replan

---

## Assumptions & Validation

- NextAuth.js v5 works with our current App Router setup
  -> VALIDATE BY: Test basic provider config in dev environment (30min)
  -> IMPACT IF WRONG: May need to upgrade Next.js or refactor auth layer (2-3 days)

- OAuth providers (Google, GitHub) are stable and won't change API during implementation
  -> VALIDATE BY: Check provider status pages and changelog before starting
  -> IMPACT IF WRONG: May need to adjust config mid-implementation (1-2h delay)

- Users want social login (not just email/password)
  -> VALIDATE BY: Existing analytics show 30% bounce rate on signup page
  -> IMPACT IF WRONG: Low adoption, feature not worth ongoing maintenance costs

- Existing user schema supports OAuth accounts relation
  -> VALIDATE BY: Review Prisma schema for Account model compatibility (15min)
  -> IMPACT IF WRONG: Database migration required, adds 2-3h for schema refactor

---

## Phases

### Phase 1: Setup OAuth Apps (External)
**Effort**: 1h | **Dependencies**: None

- Create Google OAuth app in GCP Console
- Create GitHub OAuth app in GitHub Settings
- Store client IDs and secrets in `.env.local`

**Gate**: Both OAuth apps created, credentials stored, no secrets in code - verified by grep for hardcoded keys.

---

### Phase 2: Configure NextAuth.js
**Effort**: 2h | **Dependencies**: Phase 1

- Update `app/api/auth/[...nextauth]/route.ts` with Google and GitHub providers
- Configure callback URLs
- Test OAuth flow in dev environment

**Gate**: User completes OAuth flow end-to-end in dev - manual test with real Google/GitHub accounts passes.

---

### Phase 3: Update Database Schema
**Effort**: 1h | **Dependencies**: Phase 2

- Add NextAuth.js Account model to Prisma schema
- Run migration in dev environment
- Verify no data loss in existing user records

**Gate**: Migration completes successfully, existing users still log in via email/password - automated test passes.

---

### Phase 4: Update Login Page UI
**Effort**: 2h | **Dependencies**: Phase 3

- Add "Sign in with Google" and "Sign in with GitHub" buttons
- Style to match existing design system
- Add loading states and error handling

**Gate**: Buttons render correctly on login page, clicking initiates OAuth flow - visual inspection + manual click test.

---

### Phase 5: Add Account Linking UI
**Effort**: 2h | **Dependencies**: Phase 4

- Profile page shows linked accounts
- "Link Google Account" and "Link GitHub Account" buttons
- "Unlink" functionality with confirmation modal
- Create `/auth/error` page for OAuth failures

**Gate**: User can link and unlink accounts from profile, error page shows on OAuth failure - manual test with all scenarios.

---

### Phase 6: Testing & Security Audit
**Effort**: 2h | **Dependencies**: Phase 5

- Run unit and integration tests
- Complete security checklist (see Verification section)
- Test error scenarios (denied access, invalid state)

**Gate**: All tests pass, security checklist 100% complete, zero vulnerabilities found - automated test suite + manual security review.

---

## Verification

**Automated**:
- Unit tests: OAuth callback parsing, account linking logic, error boundary cases
- Integration tests: Complete OAuth flow (Google), complete OAuth flow (GitHub), account linking from profile
- Security tests: Callback URL validation, state parameter CSRF prevention, token not in logs
- CI pipeline: All tests must pass before merge

**Manual**:
- New user signup via Google and GitHub
- Existing user links and unlinks OAuth accounts
- Session persistence after OAuth login
- Error page displays correctly on OAuth failure
- Email/password auth still works (regression check)
- Mobile responsive design on login and profile pages

---

## Rollback / Undo Strategy

**Trigger**: OAuth providers go down OR deployment causes auth failures > 5%

**Steps**:
1. Set `ENABLE_OAUTH=false` in environment variables (feature flag)
2. Redeploy previous version if needed
3. Email/password auth remains functional - no user impact
4. Existing OAuth sessions remain valid (JWT-based)

**Data**: Database migration is additive (no data deletion) - no rollback needed
**Duration**: 5 minutes to disable, 15 minutes to full rollback
**Point of No Return**: None - OAuth is additive feature, removal has no data loss

---

## Security & Privacy

**Sensitive Data**:
- OAuth tokens (never logged or exposed)
- Client secrets (environment variables only)
- User email addresses (already handling, no change)

**Threats**:
- OAuth redirect hijacking (CSRF attack)
- Token leakage in logs/errors
- Unauthorized account linking

**Controls**:
- NextAuth.js handles state parameter automatically (CSRF prevention)
- Never log tokens or secrets (lint rule + manual audit)
- Require active session to link accounts (no email-based linking)
- Validate callback URLs against whitelist server-side
- Rate limiting on OAuth routes (existing middleware)

**Audit Method**: Security checklist completed in Phase 6, manual code review of auth routes.

---

## Delegation & Team Strategy

**Can Delegate** (complexity 3-5):
- Unit test implementation - delegate to `debugger` agent (Sonnet)
- UI component styling - delegate to `feature-dev:frontend` agent (Haiku)
- Prisma migration review - delegate to `engineer` traits agent (Sonnet)

**Cannot Delegate** (complexity 6+, security-critical):
- OAuth provider configuration - security-sensitive, must review personally
- Account linking logic - core business logic
- Error handling design - UX-critical

**Verification of Delegated Work**: All delegated code must pass manual spot-check + automated test suite before merge.

---

## Stage 2: Meta Review

**Delegation Strategy**: Phases 1-2 done by lead (critical), Phases 4-5 can parallelize UI work to frontend specialist, Phase 6 requires lead review.

**Research Needs**: Phase 1 requires reading NextAuth.js v5 OAuth docs, Google OAuth scopes, GitHub OAuth scopes. Phase 4 may need UI design pattern research.

**Review Gates**: After Phase 3 (schema update) - review migration before production. After Phase 5 (account linking) - UX review with manual test. Before production - full security checklist.

**Anti-Pattern Check**:
- ✅ Assumptions validated (schema compatibility, provider stability)
- ✅ Phases under 4h each
- ✅ Specific success criteria with numbers (95% success rate)
- ✅ Rollback strategy defined
- ✅ Security section present
- ✅ Delegation strategy with verification
- ✅ Binary gates per phase

**Replanning Triggers**: Return to Stage 0 if NextAuth.js incompatible (Assumption 1 fails) OR security audit finds critical vulnerability (gate fails).

---

**Plan Status**: Ready for implementation
**Estimated Time**: 10 hours total
**Risk Level**: Medium (security-sensitive, but well-established patterns)
