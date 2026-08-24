#!/usr/bin/env bash
#
# Universal Planning Framework - installer.
#
# Copies the framework's commands, agent and rules into a project's .claude/
# directory. It never replaces a file you already have unless you ask it to,
# and when you do ask, it keeps a timestamped backup first.
#
# Usage:
#   ./setup.sh [TARGET_DIR] [OPTIONS]
#
#   TARGET_DIR         Project to install into. Default: current directory.
#
# Options:
#   --dry-run          Show what would happen. Writes nothing.
#   --skip-existing    Never prompt, never replace. Keeps every file you have.
#   --overwrite        Replace files that clash, after backing each one up.
#   -h, --help         Show this help.
#
# With no option and a terminal attached, each clash is asked about one file at
# a time. With no terminal attached (a pipe, a CI job), clashes are skipped.

set -euo pipefail
IFS=$'\n\t'

PROG=$(basename -- "$0")

die() { printf '%s: %s\n' "$PROG" "$*" >&2; exit 1; }
info() { printf '%s\n' "$*"; }

usage() {
  cat <<EOF
Universal Planning Framework - installer.

Copies the framework's commands, agent and rules into a project's .claude/
directory. It never replaces a file you already have unless you ask it to,
and when you do ask, it keeps a timestamped backup first.

Usage:
  $PROG [TARGET_DIR] [OPTIONS]

  TARGET_DIR         Project to install into. Default: current directory.

Options:
  --dry-run          Show what would happen. Writes nothing.
  --skip-existing    Never prompt, never replace. Keeps every file you have.
  --overwrite        Replace files that clash, after backing each one up.
  -h, --help         Show this help.

With no option and a terminal attached, each clash is asked about one file at
a time. With no terminal attached (a pipe, a CI job), clashes are skipped.
EOF
}

# ---------------------------------------------------------------- arguments --

MODE=ask          # ask | skip | overwrite
DRY_RUN=0
TARGET=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)       DRY_RUN=1 ;;
    # These two mean opposite things. Last-wins would hand someone who scripted
    # the flags in the wrong order the opposite of the safe behaviour, silently.
    --skip-existing)
      if [ "$MODE" = overwrite ]; then
        die "--skip-existing and --overwrite contradict each other. Pass one."
      fi
      MODE=skip ;;
    --overwrite)
      if [ "$MODE" = skip ]; then
        die "--skip-existing and --overwrite contradict each other. Pass one."
      fi
      MODE=overwrite ;;
    -h|--help)       usage; exit 0 ;;
    --)              shift; break ;;
    -*)              die "unknown option: $1 (try --help)" ;;
    *)
      [ -z "$TARGET" ] || die "more than one target directory given: '$TARGET' and '$1'"
      TARGET=$1
      ;;
  esac
  shift
done

# A target may still arrive after a bare `--`.
if [ "$#" -gt 0 ]; then
  [ -z "$TARGET" ] || die "more than one target directory given: '$TARGET' and '$1'"
  TARGET=$1
  shift
  [ "$#" -eq 0 ] || die "more than one target directory given"
fi

[ -n "$TARGET" ] || TARGET=.

# ------------------------------------------------------------------ resolve --

# Where this script lives, with every symlink resolved.
SRC_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P) \
  || die "cannot resolve the directory this script lives in"
SRC="$SRC_ROOT/.claude"

[ -d "$SRC" ] || die "no .claude/ directory next to this script (looked in $SRC_ROOT). Run setup.sh from inside a checkout of the repository."

[ -e "$TARGET" ] || die "target does not exist: $TARGET"
[ -d "$TARGET" ] || die "target is not a directory: $TARGET"

TARGET_ROOT=$(CDPATH= cd -- "$TARGET" && pwd -P) \
  || die "cannot enter target directory: $TARGET"

# Command substitution strips trailing newlines, so a directory whose name ends
# in one would resolve to a DIFFERENT directory. `-ef` compares device AND
# inode; an inode-only comparison would collide across filesystems.
[ "$TARGET" -ef "$TARGET_ROOT" ] \
  || die "resolved target '$TARGET_ROOT' is not the directory you named. Rename it so the path has no trailing whitespace or newline, then re-run."

if [ "$TARGET_ROOT" = "$SRC_ROOT" ]; then
  die "target is the framework checkout itself. Pass the project you want to install into, for example: $PROG ~/code/my-project"
fi

DEST="$TARGET_ROOT/.claude"

# A .claude that is a symlink, or a file, is not something to write through.
if [ -L "$DEST" ]; then
  die "$DEST is a symlink. Resolve it yourself and re-run against the real directory."
fi
if [ -e "$DEST" ] && [ ! -d "$DEST" ]; then
  die "$DEST exists and is not a directory."
fi

# Anything that is not a terminal cannot answer a question.
if [ "$MODE" = ask ] && { [ ! -t 0 ] || [ ! -r /dev/tty ]; }; then
  MODE=skip
fi

TS=$(date +%Y%m%d-%H%M%S)
NL='
'

# ------------------------------------------------------------------ collect --

# .DS_Store and editor swap files turn up in a working copy whatever .gitignore
# says, and installing this repo's junk into someone else's project is rude.
FILES=()
while IFS= read -r -d '' f; do
  case $(basename -- "$f") in
    .DS_Store|Thumbs.db|*.swp|*.swo|*~|.#*) continue ;;
  esac
  FILES+=("$f")
done < <(find "$SRC" -type f -print0 | LC_ALL=C sort -z)

[ "${#FILES[@]}" -gt 0 ] || die "nothing to install: no files under $SRC"

# ------------------------------------------------------------------ helpers --

# True when any directory component between DEST and the file is a symlink.
# Writing through one of those would land outside the project.
has_symlinked_parent() {
  local rel=$1 walk="$DEST" part
  local oldifs=$IFS
  # `set -f` matters as much as IFS here: without it a component containing a
  # glob character would be pathname-expanded and the walk would inspect some
  # other path, missing a real symlink.
  set -f
  IFS=/
  for part in $rel; do
    [ -n "$part" ] || continue
    walk="$walk/$part"
    if [ -L "$walk" ]; then IFS=$oldifs; set +f; return 0; fi
  done
  IFS=$oldifs
  set +f
  return 1
}

# Write src to a fresh temporary file next to dst, then move it into place.
# The move replaces the directory entry, so a hard link elsewhere keeps its
# own content, and a failed copy never leaves dst truncated.
#
# The mode argument decides what the result is chmod'ed to. Replacing a file the
# user already had must carry THEIR mode across: a file they had at 0600 must
# not come back world-readable just because it was replaced.
write_via_temp() {
  local src=$1 dst=$2 mode=${3:-644} dir tmp
  dir=$(dirname -- "$dst")
  tmp=$(mktemp -- "$dir/.upf-tmp-XXXXXX") || return 1
  if ! cat -- "$src" > "$tmp"; then rm -f -- "$tmp"; return 1; fi
  chmod "$mode" -- "$tmp" 2>/dev/null || true
  mv -f -- "$tmp" "$dst" || { rm -f -- "$tmp"; return 1; }
}

# The destination's current permission bits, or empty if they cannot be read.
mode_of() {
  stat -f '%Lp' -- "$1" 2>/dev/null || stat -c '%a' -- "$1" 2>/dev/null || true
}

# Create dst only if nothing is there. noclobber reserves the name, then the
# content goes in through a temp file so the two opens cannot be raced apart.
write_new() {
  local src=$1 dst=$2
  ( set -o noclobber; : > "$dst" ) 2>/dev/null || return 1
  if ! write_via_temp "$src" "$dst"; then
    # Give back the name we reserved, but only while it is still the empty
    # placeholder this function created.
    if [ -f "$dst" ] && [ ! -s "$dst" ]; then rm -f -- "$dst"; fi
    return 1
  fi
}

installed=0
skipped=0
replaced=0
blocked=0
aborted=0

# --------------------------------------------------------------------- main --

info "Universal Planning Framework"
info "  from: $SRC"
info "  into: $DEST"
[ "$DRY_RUN" -eq 1 ] && info "  mode: dry run, nothing is written"
info ""

for src in "${FILES[@]}"; do
  rel=${src#"$SRC"/}
  dst="$DEST/$rel"

  # dirname runs through command substitution, which eats trailing newlines, so
  # a component ending in one would be checked under the wrong name. Refuse it.
  case $rel in
    *"$NL"*)
      printf '  blocked  a source path contains a newline, refusing to install it\n'
      blocked=$((blocked + 1))
      continue
      ;;
  esac

  reldir=$(dirname -- "$rel")

  if [ "$reldir" != "." ] && has_symlinked_parent "$reldir"; then
    printf '  blocked  %s (a parent directory inside .claude/ is a symlink)\n' "$rel"
    blocked=$((blocked + 1))
    continue
  fi

  # -e is false for a dangling symlink, so -L has to be asked separately.
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ -L "$dst" ] || [ ! -f "$dst" ]; then
      printf '  blocked  %s (exists and is not a regular file)\n' "$rel"
      blocked=$((blocked + 1))
      continue
    fi

    if cmp -s -- "$src" "$dst"; then
      printf '  same     %s\n' "$rel"
      skipped=$((skipped + 1))
      continue
    fi

    decision=$MODE
    if [ "$decision" = ask ]; then
      printf '  CLASH    %s already exists and differs.\n' "$rel"
      printf '           [s]kip (default), [o]verwrite with a backup, [a]bort? '
      answer=""
      IFS= read -r answer < /dev/tty || answer=""
      case $answer in
        o|O) decision=overwrite ;;
        a|A) decision=abort ;;
        *)   decision=skip ;;
      esac
    fi

    case $decision in
      abort)
        info ""
        info "Aborted. Nothing further was written."
        aborted=1
        break
        ;;
      overwrite)
        backup="$dst.upf-backup-$TS"
        if [ "$DRY_RUN" -eq 1 ]; then
          printf '  replace  %s (backup: %s)\n' "$rel" "$(basename -- "$backup")"
          replaced=$((replaced + 1))
          continue
        fi
        if [ -e "$backup" ] || [ -L "$backup" ]; then
          printf '  blocked  %s (backup name %s is taken)\n' "$rel" "$(basename -- "$backup")"
          blocked=$((blocked + 1))
          continue
        fi
        if ! cp -p -- "$dst" "$backup"; then
          printf '  blocked  %s (could not write a backup)\n' "$rel"
          blocked=$((blocked + 1))
          continue
        fi
        if ! write_via_temp "$src" "$dst" "$(mode_of "$dst")"; then
          printf '  blocked  %s (write failed, your file is untouched)\n' "$rel"
          blocked=$((blocked + 1))
          continue
        fi
        printf '  replaced %s (backup: %s)\n' "$rel" "$(basename -- "$backup")"
        replaced=$((replaced + 1))
        ;;
      *)
        printf '  kept     %s (yours, untouched)\n' "$rel"
        skipped=$((skipped + 1))
        ;;
    esac
    continue
  fi

  # No clash.
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '  install  %s\n' "$rel"
    installed=$((installed + 1))
    continue
  fi

  if ! mkdir -p -- "$(dirname -- "$dst")"; then
    printf '  blocked  %s (could not create its directory)\n' "$rel"
    blocked=$((blocked + 1))
    continue
  fi

  if write_new "$src" "$dst"; then
    printf '  install  %s\n' "$rel"
    installed=$((installed + 1))
  else
    printf '  blocked  %s (not writable, or it appeared while installing)\n' "$rel"
    blocked=$((blocked + 1))
  fi
done

# ------------------------------------------------------------------ summary --

info ""
info "installed $installed  kept $skipped  replaced $replaced  blocked $blocked"

if [ "$aborted" -eq 1 ]; then
  exit 1
fi

if [ "$blocked" -gt 0 ]; then
  info ""
  info "Some files were not written. Nothing of yours was changed for those."
  exit 1
fi

if [ "$DRY_RUN" -eq 0 ] && [ "$installed" -gt 0 ]; then
  info ""
  info "Done. Start Claude Code in $TARGET_ROOT and run:  /plan-new \"your first plan\""
fi

exit 0
