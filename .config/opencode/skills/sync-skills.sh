#!/usr/bin/env bash
# Copy the chosen skills from the local upstream clone into OpenCode's global
# skills directory. The installed skills are ordinary files: they keep working
# if the clone moves, changes, or disappears.
#
#   ./sync-skills.sh          copy the manifest skills into place (overwrites)
#   ./sync-skills.sh --check  report status, print diffs; change nothing
#
# Env overrides: SKILLS_REPO (source clone), SKILLS_DEST (destination).
set -euo pipefail

REPO="${SKILLS_REPO:-/home/syphdias/git/private/mattpocock-skills}"
DEST="${SKILLS_DEST:-$HOME/.config/opencode/skills}"

# Your chosen skills. Edit this list as you reassess.
MANIFEST=(
  grilling
  grill-me
  handoff
  grill-with-docs
  domain-modeling
  retro
  writing-for-agents
)

CHECK=0
case "${1:-}" in
  "") ;;
  --check) CHECK=1 ;;
  *) echo "usage: $(basename "$0") [--check]" >&2; exit 2 ;;
esac
if [ "$#" -gt 1 ]; then echo "usage: $(basename "$0") [--check]" >&2; exit 2; fi

if [ ! -d "$REPO/skills" ]; then
  echo "error: no skills/ under REPO=$REPO" >&2; exit 1
fi
rev="$(git -C "$REPO" rev-parse --short HEAD 2>/dev/null || echo 'unknown revision')"
echo "source: $REPO @ $rev"

mkdir -p "$DEST"
for name in "${MANIFEST[@]}"; do
  src="$(find "$REPO/skills" -mindepth 2 -maxdepth 2 -type d -name "$name" -print -quit)"
  if [ -z "$src" ] || [ ! -f "$src/SKILL.md" ]; then
    echo "error: $name not found under $REPO/skills/*/" >&2; exit 1
  fi
  target="$DEST/$name"

  if [ "$CHECK" = 1 ]; then
    if [ -L "$target" ]; then
      echo "symlink: $name (run without --check to replace it with a copy)"
    elif [ ! -e "$target" ]; then
      echo "missing: $name (would copy $src)"
    elif diff -rq "$src" "$target" >/dev/null 2>&1; then
      echo "current: $name"
    else
      echo "differs: $name"
      diff -ru "$src" "$target" | sed 's/^/    /' || true
    fi
    continue
  fi

  rm -rf "$target"
  cp -a "$src" "$target"
  echo "copied:  $name"
done
