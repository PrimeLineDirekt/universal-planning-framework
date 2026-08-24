#!/usr/bin/env bash
# Adversarial harness for UPF setup.sh. Each case asserts on real disk state.
set -uo pipefail

REPO=$1
LAB=$2
rm -rf "$LAB"; mkdir -p "$LAB"

pass=0; fail=0
ok()   { printf 'PASS  %s\n' "$1"; pass=$((pass+1)); }
bad()  { printf 'FAIL  %s\n' "$1"; fail=$((fail+1)); }
chk()  { if [ "$2" = "$3" ]; then ok "$1"; else bad "$1  expected[$3] got[$2]"; fi; }

# ---------------------------------------------------------------- case 1 ----
# Clean target: everything installs.
T="$LAB/clean"; mkdir -p "$T"
"$REPO/setup.sh" "$T" --skip-existing >"$LAB/c1.log" 2>&1
n=$(find "$T/.claude" -type f 2>/dev/null | wc -l | tr -d ' ')
chk "1 clean target installs all 7 files" "$n" "7"

# ---------------------------------------------------------------- case 2 ----
# Partially populated target with a same-named file: must NOT be touched.
T="$LAB/partial"; mkdir -p "$T/.claude/commands" "$T/.claude/rules"
printf 'MY OWN PLAN-NEW\n' > "$T/.claude/commands/plan-new.md"
printf 'MY OWN RULE\n'     > "$T/.claude/rules/my-rule.md"
before_pn=$(cksum "$T/.claude/commands/plan-new.md" | awk '{print $1}')
before_mr=$(cksum "$T/.claude/rules/my-rule.md" | awk '{print $1}')
"$REPO/setup.sh" "$T" --skip-existing >"$LAB/c2.log" 2>&1
after_pn=$(cksum "$T/.claude/commands/plan-new.md" | awk '{print $1}')
after_mr=$(cksum "$T/.claude/rules/my-rule.md" | awk '{print $1}')
chk "2a user's plan-new.md unchanged"       "$after_pn" "$before_pn"
chk "2b user's my-rule.md unchanged"        "$after_mr" "$before_mr"
chk "2c upf universal-planning.md landed"   "$([ -f "$T/.claude/rules/universal-planning.md" ] && echo yes || echo no)" "yes"
chk "2d upf plan-review.md landed"          "$([ -f "$T/.claude/commands/plan-review.md" ] && echo yes || echo no)" "yes"

# ---------------------------------------------------------------- case 3 ----
# Target holds a file whose name contains spaces and a quote.
T="$LAB/spaces"; mkdir -p "$T/.claude/rules"
printf 'KEEP ME\n' > "$T/.claude/rules/my notes 'x'.md"
"$REPO/setup.sh" "$T" --skip-existing >"$LAB/c3.log" 2>&1
chk "3 file with spaces+quote survives" "$(cat "$T/.claude/rules/my notes 'x'.md")" "KEEP ME"

# ---------------------------------------------------------------- case 4 ----
# .claude/rules is a symlink pointing outside the project.
T="$LAB/symdir"; mkdir -p "$T/.claude" "$LAB/outside"
printf 'OUTSIDE FILE\n' > "$LAB/outside/sentinel.md"
ln -s "$LAB/outside" "$T/.claude/rules"
"$REPO/setup.sh" "$T" --skip-existing >"$LAB/c4.log" 2>&1
leak=$(find "$LAB/outside" -type f | wc -l | tr -d ' ')
chk "4a nothing written through the symlinked dir" "$leak" "1"
chk "4b sentinel intact" "$(cat "$LAB/outside/sentinel.md")" "OUTSIDE FILE"

# ---------------------------------------------------------------- case 5 ----
# Dangling symlink sitting exactly where a UPF file would go.
T="$LAB/dangling"; mkdir -p "$T/.claude/commands"
ln -s "$LAB/nope/target.md" "$T/.claude/commands/plan-new.md"
"$REPO/setup.sh" "$T" --skip-existing >"$LAB/c5.log" 2>&1
chk "5a dangling symlink still a symlink" "$([ -L "$T/.claude/commands/plan-new.md" ] && echo yes || echo no)" "yes"
chk "5b symlink target was not created"   "$([ -e "$LAB/nope/target.md" ] && echo yes || echo no)" "no"

# ---------------------------------------------------------------- case 6 ----
# Symlink pointing at a REAL file the user cares about.
T="$LAB/symfile"; mkdir -p "$T/.claude/commands" "$LAB/precious"
printf 'PRECIOUS\n' > "$LAB/precious/real.md"
ln -s "$LAB/precious/real.md" "$T/.claude/commands/plan-refine.md"
"$REPO/setup.sh" "$T" --skip-existing >"$LAB/c6.log" 2>&1
chk "6 symlink target not overwritten" "$(cat "$LAB/precious/real.md")" "PRECIOUS"

# ---------------------------------------------------------------- case 7 ----
# Installing into the framework checkout itself must be refused.
"$REPO/setup.sh" "$REPO" --skip-existing >"$LAB/c7.log" 2>&1
chk "7 self-install refused (exit 1)" "$?" "1"

# ---------------------------------------------------------------- case 8 ----
# --dry-run writes nothing.
T="$LAB/dry"; mkdir -p "$T"
"$REPO/setup.sh" "$T" --dry-run >"$LAB/c8.log" 2>&1
chk "8 dry-run created no .claude" "$([ -e "$T/.claude" ] && echo yes || echo no)" "no"

# ---------------------------------------------------------------- case 9 ----
# --overwrite backs up before replacing.
T="$LAB/over"; mkdir -p "$T/.claude/rules"
printf 'OLD RULE BODY\n' > "$T/.claude/rules/universal-planning.md"
"$REPO/setup.sh" "$T" --overwrite >"$LAB/c9.log" 2>&1
bk=$(find "$T/.claude/rules" -name 'universal-planning.md.upf-backup-*' | head -1)
chk "9a backup exists"        "$([ -n "$bk" ] && echo yes || echo no)" "yes"
chk "9b backup holds the old" "$(cat "$bk" 2>/dev/null)" "OLD RULE BODY"
chk "9c new content in place" "$(head -c 4 "$T/.claude/rules/universal-planning.md")" "$(head -c 4 "$REPO/.claude/rules/universal-planning.md")"

# --------------------------------------------------------------- case 10 ----
# Non-TTY default (no flag at all) must not overwrite.
T="$LAB/notty"; mkdir -p "$T/.claude/rules"
printf 'STILL MINE\n' > "$T/.claude/rules/universal-planning.md"
"$REPO/setup.sh" "$T" </dev/null >"$LAB/c10.log" 2>&1
chk "10 non-TTY default kept user file" "$(cat "$T/.claude/rules/universal-planning.md")" "STILL MINE"

# --------------------------------------------------------------- case 11 ----
# Target path itself contains a space.
T="$LAB/my project dir"; mkdir -p "$T"
"$REPO/setup.sh" "$T" --skip-existing >"$LAB/c11.log" 2>&1
n=$(find "$T/.claude" -type f 2>/dev/null | wc -l | tr -d ' ')
chk "11 target path with a space works" "$n" "7"

# --------------------------------------------------------------- case 12 ----
# .claude itself is a symlink.
T="$LAB/claudesym"; mkdir -p "$T" "$LAB/elsewhere"
ln -s "$LAB/elsewhere" "$T/.claude"
"$REPO/setup.sh" "$T" --skip-existing >"$LAB/c12.log" 2>&1
n=$(find "$LAB/elsewhere" -type f | wc -l | tr -d ' ')
chk "12 refused to write through symlinked .claude" "$n" "0"

# --------------------------------------------------------------- case 13 ----
# Missing target directory.
"$REPO/setup.sh" "$LAB/does-not-exist" --skip-existing >"$LAB/c13.log" 2>&1
chk "13 missing target exits 1" "$?" "1"

# --------------------------------------------------------------- case 14 ----
# Re-run on an already-installed project is a no-op.
T="$LAB/clean"
sum_before=$(find "$T/.claude" -type f -exec cksum {} \; | sort | cksum | awk '{print $1}')
"$REPO/setup.sh" "$T" --skip-existing >"$LAB/c14.log" 2>&1
sum_after=$(find "$T/.claude" -type f -exec cksum {} \; | sort | cksum | awk '{print $1}')
chk "14 idempotent re-run" "$sum_after" "$sum_before"

# --------------------------------------------------------------- case 15 ----
# THE ONE THAT MATTERS: symlink to a real file, under --overwrite.
# Skip-mode never reaches the symlink guard, so only this case tests it.
T="$LAB/symover"; mkdir -p "$T/.claude/rules" "$LAB/precious2"
printf 'PRECIOUS TWO\n' > "$LAB/precious2/real.md"
ln -s "$LAB/precious2/real.md" "$T/.claude/rules/universal-planning.md"
"$REPO/setup.sh" "$T" --overwrite >"$LAB/c15.log" 2>&1
chk "15a --overwrite did not write through the symlink" "$(cat "$LAB/precious2/real.md")" "PRECIOUS TWO"
chk "15b symlink still a symlink" "$([ -L "$T/.claude/rules/universal-planning.md" ] && echo yes || echo no)" "yes"

# --------------------------------------------------------------- case 16 ----
# Dangling symlink under --overwrite: must not create the outside target.
T="$LAB/dangover"; mkdir -p "$T/.claude/commands"
ln -s "$LAB/nowhere/created.md" "$T/.claude/commands/plan-new.md"
"$REPO/setup.sh" "$T" --overwrite >"$LAB/c16.log" 2>&1
chk "16 --overwrite did not create the dangling target" "$([ -e "$LAB/nowhere/created.md" ] && echo yes || echo no)" "no"

# --------------------------------------------------------------- case 17 ----
# Symlinked subdirectory under --overwrite: must not escape .claude/.
T="$LAB/symdirover"; mkdir -p "$T/.claude" "$LAB/outside2"
printf 'OUTSIDE TWO\n' > "$LAB/outside2/sentinel.md"
ln -s "$LAB/outside2" "$T/.claude/rules"
"$REPO/setup.sh" "$T" --overwrite >"$LAB/c17.log" 2>&1
n=$(find "$LAB/outside2" -type f | wc -l | tr -d ' ')
chk "17 --overwrite wrote nothing into the symlinked dir" "$n" "1"

# --------------------------------------------------------------- case 18 ----
# Hard link: replacing the .claude name must not rewrite the other name.
T="$LAB/hardlink"; mkdir -p "$T/.claude/rules" "$LAB/hl"
printf 'SHARED INODE\n' > "$LAB/hl/other-name.md"
ln "$LAB/hl/other-name.md" "$T/.claude/rules/universal-planning.md"
"$REPO/setup.sh" "$T" --overwrite >"$LAB/c18.log" 2>&1
chk "18 hard link elsewhere kept its content" "$(cat "$LAB/hl/other-name.md")" "SHARED INODE"

# --------------------------------------------------------------- case 19 ----
# Glob character in a source path component, with a decoy in CWD.
# Without `set -f` the parent walk inspects the decoy and misses the symlink.
G="$LAB/globrepo"; mkdir -p "$G/.claude/a*b"
cp "$REPO/setup.sh" "$G/setup.sh"; chmod +x "$G/setup.sh"
printf 'UPF PAYLOAD\n' > "$G/.claude/a*b/note.md"
T="$LAB/globtarget"; mkdir -p "$T/.claude" "$LAB/globoutside"
printf 'OUTSIDE GLOB\n' > "$LAB/globoutside/note.md"
ln -s "$LAB/globoutside" "$T/.claude/a*b"
DECOY="$LAB/decoy"; mkdir -p "$DECOY/azb"
( cd "$DECOY" && "$G/setup.sh" "$T" --overwrite ) >"$LAB/c19.log" 2>&1
chk "19 glob-named component did not escape the symlink" "$(cat "$LAB/globoutside/note.md")" "OUTSIDE GLOB"

# --------------------------------------------------------------- case 20 ----
# Target directory whose name ends in a newline resolves to a different dir.
NL='
'
NLDIR="$LAB/proj$NL"
mkdir -p "$LAB/proj/.claude/rules" "$NLDIR"
# Guard the guard: if the newline directory did not get created, this case
# proves nothing and must not report a pass.
[ -d "$NLDIR" ] && [ "$NLDIR" != "$LAB/proj" ] || bad "20-setup could not create a newline-named directory"
printf 'WRONG PROJECT FILE\n' > "$LAB/proj/.claude/rules/universal-planning.md"
"$REPO/setup.sh" "$NLDIR" --overwrite >"$LAB/c20.log" 2>&1
chk "20 newline-named target did not touch the neighbour" \
  "$(cat "$LAB/proj/.claude/rules/universal-planning.md")" "WRONG PROJECT FILE"

# --------------------------------------------------------------- case 21 ----
# A source path containing a newline is refused, not installed under a name
# that dirname would silently shorten.
N="$LAB/nlrepo"; SUB=$(printf 'sub\ndir')
mkdir -p "$N/.claude/$SUB"
cp "$REPO/setup.sh" "$N/setup.sh"; chmod +x "$N/setup.sh"
printf 'NL PAYLOAD\n' > "$N/.claude/$SUB/note.md"
T="$LAB/nltarget"; mkdir -p "$T"
"$N/setup.sh" "$T" --skip-existing >"$LAB/c21.log" 2>&1
chk "21 newline source path was blocked" \
  "$(grep -c 'contains a newline' "$LAB/c21.log")" "1"

# --------------------------------------------------------------- case 22 ----
# A write that fails must leave no zero-byte stub behind, and must exit 1.
T="$LAB/readonly"; mkdir -p "$T/.claude/rules"
chmod a-w "$T/.claude/rules"
"$REPO/setup.sh" "$T" --skip-existing >"$LAB/c22.log" 2>&1
rc=$?
chmod u+w "$T/.claude/rules"
n=$(find "$T/.claude/rules" -type f | wc -l | tr -d ' ')
chk "22a failed write left no stub file" "$n" "0"
chk "22b failed write exits 1"           "$rc" "1"

# --------------------------------------------------------------- case 23 ----
# Destination writable, SOURCE unreadable: the name is reserved and then the
# copy fails. This is the only path that reaches the stub cleanup; case 22
# does not, because there the placeholder is never created either.
U="$LAB/unreadable-repo"
mkdir -p "$U"
cp -R "$REPO/.claude" "$U/.claude"
cp "$REPO/setup.sh" "$U/setup.sh"; chmod +x "$U/setup.sh"
chmod a-r "$U/.claude/rules/universal-planning.md"
T="$LAB/stubtarget"; mkdir -p "$T"
"$U/setup.sh" "$T" --skip-existing >"$LAB/c23.log" 2>&1
chmod u+r "$U/.claude/rules/universal-planning.md"
chk "23a no zero-byte stub left behind" \
  "$([ -e "$T/.claude/rules/universal-planning.md" ] && echo yes || echo no)" "no"
chk "23b the readable siblings still installed" \
  "$([ -s "$T/.claude/rules/vehicle-selection.md" ] && echo yes || echo no)" "yes"

printf '\n%s passed, %s failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
