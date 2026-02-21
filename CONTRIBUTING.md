# Contributing to Universal Planning Framework

Thank you for your interest in improving the framework!

## Submitting Example Plans

Example plans are the best way to contribute. Requirements:

1. **Must pass self-audit honestly** - run your plan through the 21 anti-patterns and report results without rationalizations ("mostly" is not a pass)
2. **Use grades C/B/A only** - no B+, A-, or other variations
3. **Include all domain-required sections** - check Domain Detection in the rule file
4. **Coding examples must include a Reference Library** - link official docs consulted with versions and dates
5. **Include review checkpoints** for coding domain examples (every 2 phases)
6. **Include an End State paragraph** for Grade A examples
7. **Binary gates only** - no subjective words like "looks good", "acceptable", "ready"
8. **FAILED conditions must be measurable** with concrete timeouts

### PR Checklist for Examples

- [ ] Plan file in `examples/` directory
- [ ] Self-audit section honestly passes all 21 anti-patterns
- [ ] Grade matches rubric criteria (not inflated)
- [ ] Domain-specific required sections present
- [ ] Phases have clear scope boundaries (coding) or reasonable estimates (non-coding)
- [ ] All assumptions have VALIDATE BY + IMPACT IF WRONG
- [ ] FAILED conditions have measurable thresholds and timeouts

## Reporting Framework Gaps

Found a gap the framework doesn't catch? [Open an issue](https://github.com/PrimeLineDirekt/universal-planning-framework/issues) with:

1. **Description** of the gap
2. **Real example** where it caused problems
3. **Suggested detection rule** (how would the framework catch it?)
4. **Suggested fix** (what should the framework recommend?)

## Proposing Changes

For changes to the core framework (rule file, commands, agent):

1. Open an issue first to discuss the change
2. Reference specific anti-patterns, checks, or sections by number
3. Include before/after examples showing the improvement
4. Ensure cross-file consistency (rule file, README, commands, agent all reference the same counts and names)

## Code of Conduct

Be constructive. Challenge ideas, not people. Show evidence for claims.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
