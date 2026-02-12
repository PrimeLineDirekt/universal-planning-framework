---
description: Interview me about a plan before implementation
argument-hint: [plan-file]
model: opus
---

Read this plan file $ARGUMENTS and interview me in detail using the AskUserQuestion tool about literally anything:

- Technical implementation details
- UI & UX considerations
- Potential concerns and risks
- Tradeoffs and alternatives
- Edge cases and error handling
- Dependencies and prerequisites
- Testing strategy
- Deployment considerations

**Important:**
- Make sure the questions are NOT obvious
- Ask probing, in-depth questions
- Challenge assumptions
- Explore edge cases
- Continue interviewing until all aspects are covered

After the interview is complete, update the plan file with:
1. Key decisions made during interview
2. Identified risks and mitigations
3. Refined implementation approach
4. Any new requirements discovered

**CRITICAL - Plan Integrity Rules:**
- NEVER remove or modify existing tasks from the original plan
- ONLY ADD new sections: Decisions, Risks, Refinements
- If a task needs clarification, add a `[Clarified]` note BELOW the task, don't rewrite it
- Original task list = immutable baseline
- New discoveries = append to "Additional Requirements" section

---

**Source**: https://gist.github.com/robzolkos/40b70ed2dd045603149c6b3eed4649ad
**Adapted**: 2025-12-30
