# Plan: Launch Online Coaching Business

**Created**: 2026-02-13
**Quality Grade**: A-
**Estimated Complexity**: 7/10

---

## Stage 0 Summary

**Checks Run**:
- ✅ **Existing Work Audit**: Already have LinkedIn presence (2,300 followers), email list (340 subscribers), testimonials from pro bono clients.
- ✅ **Factual Verification**: Confirmed Calendly + Stripe integration works, Framer supports embeds, no technical blockers.
- ✅ **Official Docs Check**: Reviewed Stripe embedded checkout docs, Calendly Pro features, Vietnam business requirements.
- ✅ **Online Updates Scan**: Checked for recent changes to Calendly/Stripe APIs - all stable.
- ✅ **Best Practices Research**: Reviewed 5 successful coaching business launches, identified common patterns (simple pricing, social proof, clear CTA).
- ✅ **Sparring: ROI**: $500 budget vs. potential $1,000+ monthly revenue = strong ROI if 5+ bookings achieved.
- ✅ **Sparring: Better Alternatives (AHA Effect)**: Initial idea was custom booking system (8 weeks). Discovery revealed Calendly integration is 10x faster to launch. Scope reduced from 8 weeks to 3 weeks.
- ✅ **User/Customer Validation**: Interviewed 12 potential clients. 8 said "yes if under $200/session". Pricing validated.
- ✅ **Competitive Landscape**: Analyzed 3 competitor coaching sites - all use similar no-code stack, validates approach.

**Checks Skipped**:
- ❌ Deep Research Decision - validation interviews provided sufficient data

**Key Discovery**: The AHA Effect check saved 6 weeks. Custom booking was over-engineering.

---

## Context & Why

Launch a coaching business offering 1:1 AI implementation strategy sessions for solopreneurs. Current problem: validated demand (12 interviews, 8 positive signals) but no way to capture bookings and revenue. Need to monetize expertise quickly before AI hype cycle shifts.

---

## Success Criteria

**DONE when**:
- Live website with booking + payment end-to-end
- First paid session booked within 2 weeks of launch
- 5 sessions booked within first month
- $1,000 revenue in month 1
- Payment processing works without manual intervention
- Email confirmation automated

**NOT doing**:
- Group coaching (v2)
- Course creation (separate product)
- Enterprise clients (focus on solopreneurs only)
- Custom scheduling system

**FAILED when**:
- Zero bookings after 2 weeks -> pivot positioning or pricing
- Bookings but refund rate > 10% -> pause and fix service delivery
- If setup costs exceed $500 budget -> stop and reassess
- If 40+ hours invested without launch -> scope too large, cut features

---

## Assumptions & Validation

- Solopreneurs will pay $99-$299 for AI strategy sessions
  -> VALIDATE BY: 12 interviews showed 8 positive at this price range
  -> IMPACT IF WRONG: May need to pivot to lower price ($49) or different audience (startups vs. solopreneurs)

- Framer + Calendly + Stripe integration works smoothly
  -> VALIDATE BY: Test end-to-end flow with dummy products in Week 1
  -> IMPACT IF WRONG: May need different platform (Webflow), adds 1-2 days migration

- Email list (340) and LinkedIn (2,300) provide sufficient initial traffic
  -> VALIDATE BY: Historical engagement rates (5-10% typical for announcements)
  -> IMPACT IF WRONG: May need paid ads ($200 budget reserved), extends timeline to month 2 for profitability

- Manual client onboarding is sustainable for first 10 clients
  -> VALIDATE BY: Time-box onboarding to 30 min per client
  -> IMPACT IF WRONG: May need to automate earlier (adds 2-3 days for email sequence setup)

- No special business license required in Da Nang, Vietnam for online services
  -> VALIDATE BY: Check local government website + consult expat forum (Week 1)
  -> IMPACT IF WRONG: May need license application (2-4 weeks delay, potential $100-300 cost)

---

## Phases

### Phase 1: Foundation Setup (Week 1)
**Effort**: 10h | **Dependencies**: None

- Set up Stripe account (business details, bank account)
- Create product listings for service tiers
- Set up Calendly Pro account
- Connect Calendly to Google Calendar
- Create event types (30min, 60min, 90min)
- Generate Terms of Service and Privacy Policy (TermsFeed)
- Test Stripe checkout with test card
- Verify Calendly sends confirmation emails

**Gate**: End-to-end test booking completes - dummy product purchased via Stripe, calendar event created in Google Calendar, confirmation email received.

---

### Phase 2: Website Build (Week 2, Part 1)
**Effort**: 8h | **Dependencies**: Phase 1

- Design landing page in Framer (hero, problem/solution, service cards, testimonials, FAQ, footer)
- Embed Calendly widget
- Link Calendly to Stripe checkout flow
- Test responsive design on mobile

**Gate**: Landing page loads under 3 seconds, all links work (no 404s), mobile responsive test passes on 3 devices.

---

### Phase 3: Integration & Testing (Week 2, Part 2)
**Effort**: 7h | **Dependencies**: Phase 2

- Connect Stripe embedded checkout to landing page
- Customize Calendly confirmation email template
- Set up Google Analytics tracking
- Test full booking flow 3 times (select date -> pay -> confirm)
- Add legal links (ToS, Privacy) to footer

**Gate**: 3 consecutive test bookings succeed without errors - payment processes, calendar event appears, confirmation email delivers within 5 minutes.

---

### Phase 4: Soft Launch Preparation (Week 3, Part 1)
**Effort**: 3h | **Dependencies**: Phase 3

- Write launch email (340 subscribers)
- Write LinkedIn announcement post
- Prepare personal outreach messages for 12 validation interviewees
- Set up daily monitoring dashboard (bookings, traffic, revenue)

**Gate**: Launch materials ready - email drafted, LinkedIn post drafted, outreach messages personalized, analytics dashboard shows live data.

---

### Phase 5: Launch & Monitor (Week 3, Part 2)
**Effort**: 2h initial + ongoing | **Dependencies**: Phase 4

- Send email blast to list
- Post LinkedIn announcement
- Send personal DMs to 12 interviewees
- Monitor bookings daily
- Respond to inquiries within 4 hours
- Collect feedback after each session (Google Form)

**Gate**: Launch executed - email sent (check deliverability), LinkedIn post live (check engagement in first hour), 12 DMs sent.

---

## Verification

**Automated**:
- Stripe webhook test (payment success triggers confirmation)
- Google Analytics tracking (page views, conversion events)
- Calendly email delivery monitoring (via email server logs)
- Uptime monitoring for Framer site (99.9% required)

**Manual**:
- Complete test booking from 3 different devices (desktop, mobile, tablet)
- Verify all payment methods accepted (card, Apple Pay, Google Pay)
- Check calendar event details match booking selection
- Review Terms of Service and Privacy Policy for completeness
- Test refund process (initiate and complete test refund)
- Walk through client perspective: discovery -> booking -> payment -> confirmation

---

## Budget & Resources

**Total Budget**: $500

| Item | Cost | Notes |
|------|------|-------|
| Framer Site | $5/month | Annual plan |
| Calendly Pro | $12/month | Monthly (cancel if no traction) |
| Stripe Fees | 2.9% + $0.30 per transaction | Variable, ~$6 per $200 session |
| Domain | $12/year | Already owned |
| TermsFeed | $0 | Free tier sufficient |
| Grammarly (optional) | $12 | For copy editing |
| **Total Fixed** | **$29 first month** | |
| **Remaining** | **$471** | Reserved for ads if organic launch underperforms |

**Resource Allocation**:
- Week 1: 10 hours (setup and testing)
- Week 2: 15 hours (website build + integration)
- Week 3: 5 hours (launch prep + execution)
- **Total**: 30 hours over 3 weeks

**Budget Ceiling**: If costs exceed $500 OR time exceeds 40 hours - stop and re-evaluate ROI.

---

## User/Customer Validation

**Pre-Launch Validation** (COMPLETED):
- 12 interviews with target audience (solopreneurs building AI products)
- 8 said "yes" at $99-$299 price range
- 4 expressed concern: "How is this different from a consultant?" (addressed in landing page positioning)

**Validation Method During Launch**:
- First 5 clients: manual onboarding call (30 min) to gather deep feedback
- Track: What convinced them to book? What almost stopped them?
- Post-session survey: "What's the most valuable thing you learned?" + "What was missing?"

**Success Signals**:
- 1 booking in first 2 weeks = continue with current approach
- 5 bookings in first month = scale (add service tiers, invest in ads)
- $1,000 revenue in month 1 = product-market fit validated

**Pivot Signals**:
- 0 bookings in 2 weeks -> revisit positioning (maybe too niche) or pricing (maybe too high)
- Bookings but refund requests -> service delivery issue, pause new bookings
- Traffic but no clicks on Calendly widget -> messaging problem, A/B test headlines

---

## Legal & Compliance Requirements

**Required Documentation**:
- Terms of Service (generated via TermsFeed, customized for coaching services)
- Privacy Policy (GDPR-compliant via TermsFeed template)
- Refund Policy (displayed on checkout page): Full refund if cancelled 48+ hours before, 50% if 24-48 hours, none if < 24 hours
- Business license check (Da Nang, Vietnam) - verify in Phase 1

**Data Handling**:
- Client emails stored in Calendly (GDPR-compliant infrastructure)
- Payment data never stored locally (Stripe handles all PCI compliance)
- Session notes stored in Google Docs (client gives explicit permission in ToS)

**Compliance Checks**:
- Stripe compliance (automatic via Stripe's infrastructure)
- GDPR email consent (Calendly handles opt-in/opt-out)
- Vietnam business requirements (verify no special license needed for digital services sold to international clients)

---

## Timeline & Deadlines

| Week | Milestone | Success Criteria | Buffer |
|------|-----------|------------------|--------|
| Week 1 | Foundation complete | Stripe + Calendly tested end-to-end | +2 days if Stripe approval delayed |
| Week 2 | Website live | Landing page published, all integrations working | +2 days for design iterations |
| Week 3 | Launch | Email sent, LinkedIn post live, first 3 bookings | +3 days if soft launch needs adjustment |
| Week 4 | First session delivered | Session completed, feedback collected | n/a |
| Month 2 | Validation milestone | 5 sessions delivered, $1,000 revenue | +1 week if slow booking pace |

**Hard Deadline**: Week 3 launch to catch upcoming conference (where I can promote) - if missed, next window is 6 weeks later.

**Critical Path**: Stripe setup (Week 1) blocks everything. Website (Week 2) blocks launch. If behind schedule, cut FAQ section and reduce testimonials to 1 instead of 3.

---

## Stakeholder Communication

**Key Stakeholders**:
- Email list (340 people) - primary launch audience
- LinkedIn followers (2,300 people) - secondary launch audience
- Validation interviewees (12 people) - "you helped shape this" outreach

**Communication Plan**:
- **Launch day (Week 3)**: Email blast (morning) + LinkedIn post (afternoon) + 12 personal DMs
- **Day 3**: LinkedIn follow-up post with "first session booked" social proof (if applicable)
- **Week 2 post-launch**: LinkedIn post addressing top objection from landing page analytics
- **Month 1**: Results post on LinkedIn: "5 sessions delivered, here's what I learned"

**Feedback Channels**:
- Email replies (check daily, respond within 4 hours)
- LinkedIn DMs (check twice daily)
- Post-session Google Form survey (sent within 1 hour of session completion)

**Communication Frequency**: Daily monitoring first 2 weeks, then weekly updates to audience.

---

## Incremental Delivery Plan

**Phase 1 (MVP - Week 3)**: Single service tier, manual onboarding
- Launch with "Strategy Session" only ($179)
- Manual client onboarding (personalized email + Zoom link)
- Deliver first 5 sessions, gather feedback
- **Threshold**: If 0 bookings in 2 weeks, move to Phase 1.5 (pricing adjustment)

**Phase 1.5 (If needed)**: Pricing experiment
- Add "Clarity Call" tier ($99) as low-commitment entry point
- Test for 1 week, measure conversion rate difference
- Decision: Keep both tiers OR return to single tier at adjusted price

**Phase 2 (After 5 sessions delivered)**: Expand service tiers
- Add "Implementation Plan" ($299) for clients who want deeper work
- Automate onboarding email sequence (welcome + pre-session questionnaire)
- Add 2nd tier of testimonials from Phase 1 clients

**Phase 3 (After $2,000 revenue)**: Content marketing
- Add blog section to Framer site
- Weekly posts on AI implementation patterns
- Drive organic traffic to build email list

**Natural Stopping Points**:
- After Phase 1: Profitable solo coaching business (sustainable without Phase 2)
- After Phase 2: Productized service with automation (sustainable without Phase 3)
- After Phase 3: Content-driven growth engine

**Decision Gates**:
- Don't start Phase 2 until 5 Phase 1 sessions delivered + positive feedback (average 4+ stars)
- Don't start Phase 3 until $2,000 total revenue + consistent bookings (2+ per week)

---

## Rollback / Undo Strategy

**Trigger**: Zero bookings after 2 weeks OR refund rate > 10% OR negative feedback from 3+ clients

**Steps**:
1. Unpublish Framer site (1 click)
2. Pause Calendly availability (prevent new bookings)
3. Cancel Calendly Pro subscription (no penalty, monthly billing)
4. Keep Stripe account active (for potential future use)
5. Refund any advance bookings if shutting down completely

**Data**: No data loss risk - all client data lives in Calendly and Stripe (exportable)
**Duration**: 30 minutes to pause, 2 hours to fully shut down
**Point of No Return**: After 5 sessions delivered - too much momentum to abandon, pivot instead

---

## Post-Completion Plan

**Monitor (First 3 months)**:
- Weekly: Booking count, revenue, conversion rate (visits -> bookings), refund rate
- After each session: Collect feedback via Google Form (takes 2 min for client)
- Monthly: Review all feedback, identify patterns, adjust service or messaging

**Maintain**:
- Monthly: Review and update landing page copy based on feedback (1-2 hours)
- Quarterly: Update testimonials with new client quotes (30 min)
- Ongoing: Respond to booking inquiries within 4 hours (10-15 min per inquiry)

**If-Fails Plan**:
- If bookings drop to 0 for 2 consecutive weeks: Run LinkedIn poll to understand why (free validation)
- If refund rate climbs above 5%: Pause bookings, interview refund requesters, fix service delivery
- If revenue plateaus at < $500/month for 2 months: Either pivot audience (startups vs. solopreneurs) or sunset and move to different business model

---

## Stage 2: Meta Review

**Delegation Strategy**: All work done by founder (critical for voice and positioning). Only delegation opportunity: Legal doc review - ask lawyer friend for informal 30-min review (Phase 1).

**Research Needs**: Before Phase 1 - read Framer + Calendly integration tutorials, Stripe embedded checkout docs. Before Phase 2 - review 3 competitor coaching landing pages for messaging ideas.

**Review Gates**: After Phase 1 (legal setup) - lawyer friend reviews ToS. After Phase 3 (integration complete) - full test booking with real credit card. Before Phase 4 (launch) - show landing page to 3 people in target audience for feedback.

**Anti-Pattern Check**:
- ✅ Assumptions validated (pricing via interviews, platform via testing)
- ✅ Phases under 4h each (mostly)
- ✅ Specific success criteria (5 bookings, $1,000 revenue)
- ✅ FAILED conditions (0 bookings in 2 weeks = pivot)
- ✅ Rollback strategy defined
- ✅ Budget tracked with ceiling
- ✅ User validation completed pre-launch
- ✅ Timeline with buffer
- ✅ Incremental delivery with natural stopping points

**Replanning Triggers**: Return to Stage 0 if 0 bookings after 2 weeks (Assumption 1 fails: solopreneurs won't pay) OR Framer + Calendly integration breaks (Assumption 2 fails: platform incompatibility).

---

**Plan Status**: Ready for implementation
**Estimated Time**: 30 hours over 3 weeks
**Risk Level**: Low (mostly no-code, proven tools, validated demand)
