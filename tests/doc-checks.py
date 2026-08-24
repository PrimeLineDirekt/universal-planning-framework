#!/usr/bin/env python3
"""Mechanical documentation checks.

Each one exists because a review round found a defect it would have caught:

1. The verify-report template fenced a markdown example with three backticks while
   the example itself contained fenced blocks. The first inner fence closed the
   outer one, so everything after it rendered as a single blob on GitHub. Fence
   PARITY cannot see this: the count stays even either way.
2. Renaming a CONDITIONAL section left the claimed count one short of the list, in
   three files that each assert it.
"""
import pathlib
import re
import subprocess
import sys

RULEBOOK = pathlib.Path(".claude/rules/universal-planning.md")
COUNT_ASSERTERS = [pathlib.Path(".claude/commands/plan-new.md"), pathlib.Path("README.md")]

FENCE = re.compile(r"^(`{3,})\s*([A-Za-z0-9_+-]*)\s*$")
CLAIM = re.compile(r"\*?\*?(\d+) CONDITIONAL [Ss]ections", re.IGNORECASE)

failures = []


def tracked_markdown():
    out = subprocess.run(["git", "ls-files", "*.md"], capture_output=True, text=True, check=True)
    return [pathlib.Path(p) for p in out.stdout.split("\n") if p]


def check_markdown_fence_width(path):
    """A markdown example must be fenced with four backticks, always.

    A ```markdown block whose body contains fenced blocks is closed early by the
    first inner fence, and the result is still SYNTACTICALLY VALID markdown, just
    not what the author meant. No parser-level rule can separate the two cases, so
    the policy is uniform instead of clever: every markdown example uses four.
    """
    for i, line in enumerate(path.read_text().split("\n"), 1):
        if re.fullmatch(r"```(markdown|md)\s*", line):
            failures.append(
                f"{path}:{i} a markdown example is fenced with 3 backticks. "
                f"Use 4, so an inner fence cannot close it early."
            )


def check_unclosed_fences(path):
    """A fence that is never closed."""
    lines = path.read_text().split("\n")
    open_ticks = None   # length of the fence currently open, or None
    open_line = 0
    for i, line in enumerate(lines, 1):
        m = FENCE.match(line)
        if not m:
            continue
        ticks = len(m.group(1))
        if open_ticks is None:
            open_ticks, open_line = ticks, i
        elif ticks >= open_ticks and not m.group(2):
            # CommonMark: a closing fence is at least as long as its opener and
            # carries no info string. Anything else, including a LONGER fence used
            # as content, stays inside the block.
            open_ticks = None
    if open_ticks is not None:
        failures.append(f"{path}:{open_line} fence is never closed")


def check_conditional_count():
    text = RULEBOOK.read_text()
    m = CLAIM.search(text)
    if not m:
        failures.append(f"{RULEBOOK}: no CONDITIONAL count claim found")
        return
    claimed = int(m.group(1))
    body = text[m.end():]
    body = body.split("\n---", 1)[0]
    actual = len([l for l in body.split("\n") if l.startswith("- **")])
    if claimed != actual:
        failures.append(f"{RULEBOOK} claims {claimed} CONDITIONAL sections, the list has {actual}")
    else:
        print(f"rulebook CONDITIONAL count agrees with its list ({actual})")
    for p in COUNT_ASSERTERS:
        text_p = p.read_text()
        for n in {int(x) for x in CLAIM.findall(text_p)}:
            if n != claimed:
                failures.append(f"{p} says {n} CONDITIONAL sections, the rulebook says {claimed}")
        # A matching numeral is not a matching list. Where the file spells the
        # sections out inline, count the names too.
        m2 = re.search(r"\*\*\d+ CONDITIONAL sections\*\*[^:]*:\s*([^\n]+)", text_p)
        if m2:
            named = [s.strip() for s in m2.group(1).rstrip(".").split(",") if s.strip()]
            if len(named) != claimed:
                failures.append(
                    f"{p} claims {claimed} CONDITIONAL sections and then names {len(named)}"
                )


for md in tracked_markdown():
    check_markdown_fence_width(md)
    check_unclosed_fences(md)
if not failures:
    print("every markdown example uses a 4-backtick fence; no fence is left open")
check_conditional_count()

if failures:
    print("\n".join(failures), file=sys.stderr)
    sys.exit(1)
print("documentation checks passed")
