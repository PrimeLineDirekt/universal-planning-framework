# Plan: Write and Publish Technical E-book on AI Agents

**Created**: 2026-02-13
**Quality Grade**: B
**Confidence Level**: Medium
**Estimated Complexity**: 6/10

---

## Stage 0 Summary

**Checks Run**:
- ✅ **Existing Work Audit**: Have 15 blog posts on AI agents already written. Can repurpose 40% of content. Have email list of 1,200 developers.
- ✅ **Factual Verification**: Confirmed Gumroad supports PDF delivery, code syntax highlighting, and handles VAT automatically.
- ✅ **Official Docs Check**: Reviewed OpenAI and Anthropic API docs for latest patterns, Gumroad seller documentation.
- ✅ **Best Practices Research**: Analyzed 5 top-selling Gumroad technical e-books - identified patterns (60-80 pages, practical code, $20-40 price point).
- ✅ **Sparring: Better Alternatives (AHA Effect)**: Initial idea was comprehensive 300-page book on all AI topics. Survey of potential readers revealed they want focused, actionable guides. Pivoted to "Building AI Agents: A 60-Page Practical Guide" - 5x faster to produce, higher completion rate.
- ✅ **User/Customer Validation**: Surveyed email list - 180 responses, 67% said "I'd buy this for $20-40". Topic validated.
- ✅ **Competitive Landscape**: Checked 3 similar e-books - topics overlap but none focus specifically on agent patterns with production code examples.

**Checks Skipped**:
- ❌ Online Updates Scan - APIs stable, user confirmed
- ❌ Deep Research Decision - sufficient validation data from survey
- ❌ ROI - low cost project, validated demand

**Key Discovery**: The AHA Effect check saved months. Shifted from academic tome to practical guide based on actual reader feedback.

---

## Context & Why

Write and publish a 60-page practical guide on building AI agents for developers. Problem: developers struggle with agent implementation patterns beyond basic chatbots. Opportunity: capitalize on AI hype cycle while interest is high and position as expert in the space.

---

## Success Criteria

**DONE when**:
- 60 pages of content delivered (including code examples)
- 5 complete agent examples with working code
- Published on Gumroad with sales page
- 50 copies sold in first month
- $1,000 revenue in first month (at $20 price point)
- Average rating 4+ stars from first 10 reviews

**NOT doing**:
- Physical print edition
- Video course companion
- Community/Discord for readers
- Ongoing updates (this is v1.0, not a living document)

**FAILED when**:
- Under 20 sales in first month -> pricing or positioning issue, reassess
- Refund rate > 10% -> content quality problem, pause sales and fix
- If 60+ hours invested without launch -> scope creep, cut features
- Rating below 3.5 stars after 10 reviews -> content doesn't meet expectations, major revision needed

---

## Assumptions & Validation

- Developers want practical code examples over theory
  -> VALIDATE BY: Survey showed 73% prefer "copy-paste-run" code vs. conceptual explanations
  -> IMPACT IF WRONG: May need to add more theory sections, extends timeline by 1-2 weeks

- 60 pages is the right length (not too short, not overwhelming)
  -> VALIDATE BY: Survey feedback - "focused and actionable, not overwhelming"
  -> IMPACT IF WRONG: If too short, may need to expand to 80-100 pages (adds 2 weeks). If too long, completion rate suffers.

- Python is the right language choice (not JavaScript)
  -> VALIDATE BY: 73% of survey respondents use Python for AI work
  -> IMPACT IF WRONG: May alienate JS audience, but validated by data

- Existing blog posts provide 40% of content (saves time)
  -> VALIDATE BY: Review blog posts against outline in Week 1
  -> IMPACT IF WRONG: May need to write more from scratch, adds 1-2 weeks to timeline

- Gumroad + email list provide sufficient distribution (no paid ads needed initially)
  -> VALIDATE BY: Historical email open rates (25-30%), Twitter engagement (5-10%)
  -> IMPACT IF WRONG: May need to invest in ads ($200 budget reserved), delays profitability to month 2

---

## Phases

### Phase 1: Outline & Content Audit (Week 1)
**Effort**: 4h | **Dependencies**: None

- Create detailed 6-chapter outline with subsections
- Map existing blog posts to outline
- Identify content gaps (what needs writing from scratch)
- Estimate writing effort per chapter

**Gate**: Complete outline with 6 chapters, clear mapping of existing vs. new content, total word count target defined (15,000-18,000 words for 60 pages).

---

### Phase 2: Repurpose Existing Content (Week 2)
**Effort**: 4h | **Dependencies**: Phase 1

- Copy relevant blog post sections into Google Doc
- Light editing for consistency and tone
- Mark transitions where new content needed
- Verify 40% repurpose target achieved

**Gate**: ~24 pages of content integrated from blog posts, maintains consistent voice, transitions clearly marked.

---

### Phase 3a: Write Chapter 1 - Introduction & Agent Fundamentals (Week 3)
**Effort**: 4h | **Dependencies**: Phase 2

- Write Chapter 1 (Introduction) - foundations, why agents matter, what readers will build
- Focus on practical patterns over theory
- Leave placeholder sections for code examples

**Gate**: Chapter 1 complete (~10 pages), consistent casual tone, transitions from repurposed content are smooth.

---

### Phase 3b: Write Chapter 2 - Architecture & Memory Systems (Week 3)
**Effort**: 4h | **Dependencies**: Phase 3a

- Write Chapter 2 (Architecture) and Chapter 3 (Memory Systems)
- Focus on practical patterns over theory
- Leave placeholder sections for code examples

**Gate**: Chapters 2-3 complete (~20 pages cumulative), architecture diagrams described, memory patterns explained with code pseudocode.

---

### Phase 3c: Write Chapter 4 - Tool Use & Function Calling (Week 4)
**Effort**: 4h | **Dependencies**: Phase 3b

- Write Chapter 4 (Tool Use) - practical patterns for function calling, tool integration
- Focus on practical patterns over theory
- Leave placeholder sections for code examples

**Gate**: Chapter 4 complete (~10 pages), at least 2 practical patterns with code placeholders marked.

---

### Phase 3d: Write Chapters 5-6 - Multi-Agent & Deployment (Week 4)
**Effort**: 4h | **Dependencies**: Phase 3c

- Write Chapter 5 (Multi-Agent) and Chapter 6 (Deployment)
- Focus on practical patterns over theory
- Leave placeholder sections for code examples

**Gate**: All 6 chapters drafted (60 pages total), placeholder sections marked for code integration, consistent casual tone maintained.

---

### Phase 4a: Build Core Examples (Week 5, Part 1)
**Effort**: 4h | **Dependencies**: Phase 3d

- Build Example 1: Simple RAG agent
- Build Example 2: Function-calling agent
- Build Example 3: Memory-equipped agent

**Gate**: Examples 1-3 run successfully in clean Python 3.11 environment, no dependencies beyond OpenAI/Anthropic + standard libraries.

---

### Phase 4b: Build Advanced Examples (Week 5, Part 1)
**Effort**: 4h | **Dependencies**: Phase 4a

- Build Example 4: Multi-agent system
- Build Example 5: Production-ready agent with monitoring

**Gate**: All 5 examples run successfully in clean Python 3.11 environment, documented with inline comments.

---

### Phase 5: Code Integration & Testing (Week 5, Part 2)
**Effort**: 2h | **Dependencies**: Phase 4b

- Add code snippets to chapters
- Verify syntax highlighting renders correctly
- Test all examples one more time
- Add explanatory comments to complex sections

**Gate**: Code examples integrated into chapters, syntax highlighting correct, all examples tested and working.

---

### Phase 6a: Content Editing (Week 6, Part 1)
**Effort**: 3h | **Dependencies**: Phase 5

- Full editing pass (cut 20%, tighten language)
- Check for jargon without definitions
- Verify consistent voice (casual, practical)

**Gate**: Content reduced by 15-20%, no unexplained jargon, voice consistent throughout.

---

### Phase 6b: Final Polish & Formatting (Week 6, Part 1)
**Effort**: 2h | **Dependencies**: Phase 6a

- Generate table of contents
- Add learning outcomes to each chapter intro
- Final proofread

**Gate**: TOC generated with correct page references, learning outcomes present in all 6 chapters, under 65 pages total.

---

### Phase 7: Publish & Launch (Week 6, Part 2)
**Effort**: 4h | **Dependencies**: Phase 6

- Generate PDF via Gumroad template
- Create Gumroad sales page (title, description, preview pages)
- Write launch email to 1,200-person list
- Write Twitter thread (10 tweets)
- Write LinkedIn post
- Launch: send email, post on Twitter and LinkedIn

**Gate**: PDF published on Gumroad, sales page live with preview, launch email sent (verify deliverability), social posts published.

---

## Verification

**Automated**:
- Python code examples run in automated test (GitHub Actions)
- Syntax highlighting validation (visual inspection via script)
- PDF generation successful (no broken links or images)
- Link checker for external resources in PDF

**Manual**:
- Test all 5 code examples in clean Python 3.11 environment
- Read-through of full e-book for flow and consistency
- Check table of contents links to correct pages
- Verify Gumroad test purchase delivers PDF correctly
- Review sales page for typos and broken links
- Test download on 3 devices (desktop, mobile, tablet)

**Ongoing Observability**:
- Track engagement metrics weekly (views, shares, comments per post)
- Monitor SEO rankings monthly for target keywords
- Alert if any post drops below baseline engagement rate

---

## Budget & Resources

**Total Budget**: $200

| Item | Cost | Notes |
|------|------|-------|
| Gumroad fees | 10% of sales | Variable, ~$2 per $20 sale |
| OpenAI API (testing) | ~$15 | One-time for code example testing |
| Anthropic API (testing) | ~$10 | One-time for code example testing |
| Grammarly Premium | $12 | 1 month for editing pass |
| Canva Pro | $13 | 1 month for cover design, cancel after |
| **Total Fixed** | **$50** | |
| **Remaining** | **$150** | Reserved for ads if organic launch underperforms |

**Resource Allocation**:
- Writing: 24 hours (4h outline + 4h repurpose + 16h new content)
- Code examples: 10 hours (8h build + 2h integration)
- Polish & launch: 9 hours (5h edit + 4h publish)
- **Total**: 43 hours over 6 weeks (~7 hours/week)

**Budget Ceiling**: If costs exceed $200 OR time exceeds 50 hours - stop and reassess ROI.

---

## User/Customer Validation

**Pre-Launch Validation** (COMPLETED):
- Email survey: 180 responses, 67% would buy at $20-40
- Twitter poll: 340 votes, 58% interested
- 5 beta readers reviewed outline, all said "I'd buy this"

**Validation Method During Launch**:
- First 20 buyers: send personal email asking "What's the most valuable thing you learned?" and "What's missing that you expected?"
- Track refund reasons (Gumroad provides this data)
- Monitor ratings/reviews on Gumroad

**Success Signals**:
- 20+ sales in first week = strong launch, continue with current approach
- 50 sales in month 1 = hit target, plan v2.0 based on feedback
- Average 4+ star rating = content quality validated

**Pivot Signals**:
- High refund rate (>10%) -> content quality issue, needs major revision
- Good traffic to sales page, no conversions -> pricing or sales page copy issue
- Sales but low ratings (<3.5) -> content doesn't match expectations, survey buyers to understand gap

---

## Incremental Delivery Plan

**Phase 1 (MVP - Week 6)**: Core book, PDF only
- 60 pages, 5 working examples
- Gumroad delivery
- Launch to email list (1,200 people)
- Price: $20

**Phase 2 (After 50 sales)**: Community feedback integration
- Collect feedback from first 20 buyers
- Add 1-2 bonus sections based on top requests (e.g., "Testing AI Agents" if frequently requested)
- Update PDF (free update for existing buyers)
- No price increase

**Phase 3 (After 200 sales OR 3 months)**: Companion resources
- Create public GitHub repo with starter templates
- Add video walkthrough of 1 complex example (30-min screencast)
- Price increase to $29 for new buyers (existing stay at $20)
- Market as "expanded edition"

**Natural Stopping Points**:
- After Phase 1: Complete standalone e-book (profitable without Phase 2)
- After Phase 2: Enhanced e-book with community input (profitable without Phase 3)
- After Phase 3: Premium package with code + video

**Decision Gates**:
- Don't start Phase 2 until 50 sales + average 4+ stars
- Don't start Phase 3 until 200 sales OR 3 months post-launch (whichever first)

---

## Timeline & Deadlines

| Week | Milestone | Success Criteria | Buffer |
|------|-----------|------------------|--------|
| Week 1 | Outline complete | 6 chapters outlined, gaps identified | +1 day if outline needs iteration |
| Week 2 | Repurposing done | 24 pages from blog posts | +1 day if editing takes longer |
| Week 3 | Chapters 1-3 written | 30 pages of new content | +2 days for writing delays |
| Week 4 | All chapters written | 60 pages complete (rough draft) | +2 days for writing delays |
| Week 5 | Code examples done | All 5 examples tested and integrated | +1 day for debugging |
| Week 6 | Launch | PDF live, email sent | +2 days for polish iterations |

**Self-Imposed Deadline**: 6 weeks to catch current AI hype cycle. If delayed beyond 8 weeks, market interest may shift.

**Critical Path**: Writing (Weeks 3-4) is longest phase. If behind schedule, cut Chapter 5 (Multi-Agent) from 12 pages to 6 pages.

---

## Rollback / Undo Strategy

**Trigger**: Refund rate > 10% OR average rating < 3 stars after 10 reviews OR zero sales after 1 week

**Steps**:
1. Unpublish Gumroad listing (prevent new sales)
2. Email all buyers offering full refund + apology
3. Analyze feedback to identify core issues
4. Decide: Fix and relaunch OR sunset project

**Data**: All content lives in Google Docs (no data loss). Buyer list exportable from Gumroad.
**Duration**: 1 hour to unpublish and pause sales
**Point of No Return**: After 100+ sales - too much traction to abandon, pivot to fixes instead

---

## Post-Completion Plan

**Monitor (First 3 months)**:
- Weekly: Sales count, revenue, refund rate, average rating
- Monthly: Review all feedback comments, identify patterns for v2.0
- Track which chapters readers engage with most (Gumroad provides page view analytics for PDFs)

**Maintain**:
- Respond to buyer questions within 24 hours (email support)
- Monthly: Check if code examples still work with latest API versions (10 min test)
- Quarterly: Decide if content update needed (if APIs changed significantly)

**If-Fails Plan**:
- If sales drop to < 5/week after month 1: Run Twitter poll to understand why (free validation)
- If refund rate climbs above 5%: Pause sales, interview refund requesters, fix issues before relaunching
- If revenue plateaus at < $500 total after 3 months: Sunset and move to different content format (maybe video course instead)

---

## Resume Protocol

**TL;DR**: Write 60-page practical AI agents e-book for developers, $20 on Gumroad, 5 working code examples, validated by 180-person survey.

**Context Load Order**:
1. This plan file
2. Google Doc with manuscript (check current chapter progress)
3. Code examples folder (check which examples are built and tested)

**Last Completed**: Plan created
**Next Action**: Phase 1 - Outline & Content Audit
**Blockers**: None

**Update this section after each work session.**

---

## Stage 2: Meta Review

**Delegation Strategy**: Writing requires personal expertise and voice (cannot delegate). Code examples can be partially delegated - use debugger agent to verify examples run and catch edge cases (Sonnet, complexity 4).

**Research Needs**: Before Phase 1 - review top 5 Gumroad technical e-books for sales page patterns, read "Writing for Developers" guide. Before Phase 3 - review latest OpenAI and Anthropic docs for API updates.

**Review Gates**: After Week 2 (outline + repurposing) - show to 2 beta readers, confirm direction. After Week 4 (all chapters drafted) - full editing pass before code integration. After Week 5 (code examples) - have 1 developer friend test all examples. Before launch - show sales page to 3 people in target audience.

**Anti-Pattern Check**:
- ✅ Assumptions validated (pricing via survey, length via feedback)
- ✅ Phases under 4h each
- ✅ Specific success criteria (50 sales, $1,000 revenue, 4+ stars)
- ✅ FAILED conditions (< 20 sales, >10% refunds, <3.5 stars)
- ✅ Budget tracked with ceiling
- ✅ User validation completed pre-launch
- ✅ Timeline with buffer
- ✅ Incremental delivery with natural stopping points

**Replanning Triggers**: Return to Stage 0 if refund rate > 10% in first week (Assumption 1 fails: content quality issue) OR zero sales after launch (Assumption 5 fails: distribution channels insufficient).

---

**Plan Status**: Ready for implementation
**Estimated Time**: 43 hours over 6 weeks
**Risk Level**: Low (writing-heavy, proven distribution platform, validated topic)
