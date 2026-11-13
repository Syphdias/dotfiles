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

# Your chosen skills. Put a skill's requirements behind it; duplicates are
# filtered (first occurrence wins). A name that resolves nowhere fails the run
# before anything is written.
MANIFEST=(
    grill-me grilling
    handoff
    teach
    wait-what

    setup-matt-pocock-skills
    grill-with-docs grilling domain-modeling
    triage grilling domain-modeling
    improve-codebase-architecture grilling codebase-design domain-modeling
    to-spec
    to-tickets
    # The tracker skills only work in a repo where setup-matt-pocock-skills has
    # run: code-review reads docs/agents/issue-tracker.md.
    implement tdd code-review
    implement-spec to-spec to-tickets tdd code-review
    retro writing-for-agents
    tdd codebase-design
    prototype
    diagnosing-bugs
    research
    wayfinder grilling domain-modeling research prototype
)

CHECK=0
case "${1:-}" in
"") ;;
--check) CHECK=1 ;;
*)
    echo "usage: $(basename "$0") [--check]" >&2
    exit 2
    ;;
esac
if [ "$#" -gt 1 ]; then
    echo "usage: $(basename "$0") [--check]" >&2
    exit 2
fi

if [ ! -d "$REPO/skills" ]; then
    echo "error: no skills/ under REPO=$REPO" >&2
    exit 1
fi
rev="$(git -C "$REPO" rev-parse --short HEAD 2>/dev/null || echo 'unknown revision')"
echo "source: $REPO @ $rev"

# Pre-flight: dedupe and resolve every entry before touching DEST, so a typo
# aborts the whole run instead of half-applying the manifest.
declare -A SEEN=() SRC_OF=()
ORDER=()
for name in "${MANIFEST[@]}"; do
    if [[ -n "${SEEN[$name]+x}" ]]; then
        continue
    fi
    SEEN[$name]=1
    src="$(find "$REPO/skills" -mindepth 2 -maxdepth 2 -type d -name "$name" -print -quit)"
    if [ -z "$src" ] || [ ! -f "$src/SKILL.md" ]; then
        echo "error: $name not found under $REPO/skills/*/" >&2
        exit 1
    fi
    SRC_OF[$name]="$src"
    ORDER+=("$name")
done

# Closure: every skill a manifest skill calls must itself be in the manifest.
closure_warnings=0
for name in "${ORDER[@]}"; do
    # shellcheck disable=SC2016  # backticks and quotes in the patterns are literal
    for dep in $(grep -oE 'Skill tool[^.]*' "${SRC_OF[$name]}/SKILL.md" |
        grep -oE '"[a-z0-9-]+"|`[a-z0-9-]+`' | tr -d '"`' | sort -u || true); do
        if [[ -z "${SEEN[$dep]+x}" ]]; then
            echo "warning: $name calls $dep, which is not in the manifest" >&2
            closure_warnings=$((closure_warnings + 1))
        fi
    done
done

mkdir -p "$DEST"
for name in "${ORDER[@]}"; do
    src="${SRC_OF[$name]}"
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

echo "done: ${#ORDER[@]} skills"
if [ "$closure_warnings" -gt 0 ]; then
    echo "closure: $closure_warnings warning(s)"
else
    echo "closure: ok"
fi
