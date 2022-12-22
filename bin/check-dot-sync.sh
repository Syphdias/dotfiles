#!/usr/bin/env bash

set -e

repo=""

for d in "${XDG_CONFIG_HOME:-${HOME}/.config}/dotgit/"*; do
    GIT_SSH_COMMAND="command ssh -o BatchMode=yes" \
        /usr/bin/git --git-dir="${d}/" --work-tree="${d}/" fetch || true
    /usr/bin/git --git-dir="${d}/" --work-tree="${d}/" log --format=format:"%d" -1 --all \
            |grep "origin/master" | grep -q "HEAD -> master" \
        || repo="${repo}${d:t}\n"
done

[[ -n "${repo}" ]] \
    && /usr/bin/notify-send "dotfiles not synced" "$repo" \
    || true
