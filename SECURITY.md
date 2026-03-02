# Security Policy

## Scope

This is a pure markdown project - no executable code, no dependencies, no build step. The attack surface is minimal.

That said, if you find something that could be exploited (e.g., prompt injection patterns in skill definitions, or content that could trick Claude Code into unsafe behavior), we want to know.

## Reporting a Vulnerability

**Do not open a public issue for security concerns.**

Instead, email: hello@primeline.cc

Include:
- Description of the issue
- Steps to reproduce
- Potential impact
- Suggested fix (if you have one)

We will acknowledge receipt within 48 hours and provide an update within 7 days.

## What We Consider Security Issues

- Prompt injection patterns that could bypass Claude Code safety
- Content that could trick users into running dangerous commands
- Sensitive information accidentally committed
- Anything that could harm users who install this framework

## What We Don't Consider Security Issues

- Markdown rendering differences across viewers
- Cosmetic issues in documentation
- Feature requests or general bugs (use GitHub Issues for these)
