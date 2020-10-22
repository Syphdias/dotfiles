for keymap in emacs viins vicmd; do
  # If NumLock is off, translate keys to make them appear the same as with NumLock on.
  bindkey -M $keymap -s '^[OM'     '^M'      # enter
  bindkey -M $keymap -s '^[Ok'     '+'
  bindkey -M $keymap -s '^[Om'     '-'
  bindkey -M $keymap -s '^[Oj'     '*'
  bindkey -M $keymap -s '^[Oo'     '/'
  bindkey -M $keymap -s '^[OX'     '='

  # If someone switches our terminal to application mode (smkx), translate keys to make
  # them appear the same as in raw mode (rmkx).
  bindkey -M $keymap -s '^[OA'     '^[[A'    # up
  bindkey -M $keymap -s '^[OB'     '^[[B'    # down
  bindkey -M $keymap -s '^[OD'     '^[[D'    # left
  bindkey -M $keymap -s '^[OC'     '^[[C'    # right
  bindkey -M $keymap -s '^[OH'     '^[[H'    # home
  bindkey -M $keymap -s '^[OF'     '^[[F'    # end

  # TTY sends different key codes. Translate them to xterm equivalents.
  # Missing: {ctrl,alt,shift}+{up,down,left,right,home,end}, {ctrl,alt}+delete.
  bindkey -M $keymap -s '^[[1~'    '^[[H'    # home
  bindkey -M $keymap -s '^[[4~'    '^[[F'    # end

  # Urxvt sends different key codes. Translate them to xterm equivalents.
  bindkey -M $keymap -s '^[[7~'    '^[[H'    # home
  bindkey -M $keymap -s '^[[8~'    '^[[F'    # end
  bindkey -M $keymap -s '^[Oa'     '^[[1;5A' # ctrl+up
  bindkey -M $keymap -s '^[Ob'     '^[[1;5B' # ctrl+down
  bindkey -M $keymap -s '^[Od'     '^[[1;5D' # ctrl+left
  bindkey -M $keymap -s '^[Oc'     '^[[1;5C' # ctrl+right
  bindkey -M $keymap -s '^[[7\^'   '^[[1;5H' # ctrl+home
  bindkey -M $keymap -s '^[[8\^'   '^[[1;5F' # ctrl+end
  bindkey -M $keymap -s '^[[3\^'   '^[[3;5~' # ctrl+delete
  bindkey -M $keymap -s '^[^[[A'   '^[[1;3A' # alt+up
  bindkey -M $keymap -s '^[^[[B'   '^[[1;3B' # alt+down
  bindkey -M $keymap -s '^[^[[D'   '^[[1;3D' # alt+left
  bindkey -M $keymap -s '^[^[[C'   '^[[1;3C' # alt+right
  bindkey -M $keymap -s '^[^[[7~'  '^[[1;3H' # alt+home
  bindkey -M $keymap -s '^[^[[8~'  '^[[1;3F' # alt+end
  bindkey -M $keymap -s '^[^[[3~'  '^[[3;3~' # alt+delete
  bindkey -M $keymap -s '^[[a'     '^[[1;2A' # shift+up
  bindkey -M $keymap -s '^[[b'     '^[[1;2B' # shift+down
  bindkey -M $keymap -s '^[[d'     '^[[1;2D' # shift+left
  bindkey -M $keymap -s '^[[c'     '^[[1;2C' # shift+right
  bindkey -M $keymap -s '^[[7$'    '^[[1;2H' # shift+home
  bindkey -M $keymap -s '^[[8$'    '^[[1;2F' # shift+end

  # Tmux sends different key codes. Translate them to xterm equivalents.
  bindkey -M $keymap -s '^[[1~'    '^[[H'    # home
  bindkey -M $keymap -s '^[[4~'    '^[[F'    # end
  bindkey -M $keymap -s '^[^[[A'   '^[[1;3A' # alt+up
  bindkey -M $keymap -s '^[^[[B'   '^[[1;3B' # alt+down
  bindkey -M $keymap -s '^[^[[D'   '^[[1;3D' # alt+left
  bindkey -M $keymap -s '^[^[[C'   '^[[1;3C' # alt+right
  bindkey -M $keymap -s '^[^[[1~'  '^[[1;3H' # alt+home
  bindkey -M $keymap -s '^[^[[4~'  '^[[1;3F' # alt+end
  bindkey -M $keymap -s '^[^[[3~'  '^[[3;3~' # alt+delete

  # iTerm2 sends different key codes. Translate them to xterm equivalents.
  # Missing (depending on settings): ctrl+{up,down,left,right}, {ctrl,alt}+{delete,backspace}.
  bindkey -M $keymap -s '^[^[[A'   '^[[1;3A' # alt+up
  bindkey -M $keymap -s '^[^[[B'   '^[[1;3B' # alt+down
  bindkey -M $keymap -s '^[^[[D'   '^[[1;3D' # alt+left
  bindkey -M $keymap -s '^[^[[C'   '^[[1;3C' # alt+right
  bindkey -M $keymap -s '^[[1;9A'  '^[[1;3A' # alt+up
  bindkey -M $keymap -s '^[[1;9B'  '^[[1;3B' # alt+down
  bindkey -M $keymap -s '^[[1;9D'  '^[[1;3D' # alt+left
  bindkey -M $keymap -s '^[[1;9C'  '^[[1;3C' # alt+right
  bindkey -M $keymap -s '^[[1;9H'  '^[[1;3H' # alt+home
  bindkey -M $keymap -s '^[[1;9F'  '^[[1;3F' # alt+end

  # TODO: Add missing translations.
done

# Move cursor one char backward.
bindkey   '^[[D'    backward-char                  # left
# Move cursor one char forward.
bindkey   '^[[C'    forward-char                   # right
# Move cursor one line up or fetch the previous command from LOCAL history.
bindkey   '^P'      z4h-up-local-history           # ctrl+p
bindkey   '^[[A'    z4h-up-local-history           # up
# Move cursor one line down or fetch the next command from LOCAL history.
bindkey   '^N'      z4h-down-local-history         # ctrl+n
bindkey   '^[[B'    z4h-down-local-history         # down
# Move cursor one line up or fetch the previous command from GLOBAL history.
bindkey   '^[[1;5A' z4h-up-global-history          # ctrl+up
# Move cursor one line down or fetch the next command from GLOBAL history.
bindkey   '^[[1;5B' z4h-down-global-history        # ctrl+down
# Move cursor to the beginning of line.
bindkey   '^[[H'    beginning-of-line              # home
# Move cursor to the end of line.
bindkey   '^[[F'    end-of-line                    # end
# Move cursor to the beginning of buffer.
bindkey   '^[[1;5H' z4h-beginning-of-buffer        # ctrl+home
bindkey   '^[[1;3H' z4h-beginning-of-buffer        # alt+home
# Move cursor to the end of buffer.
bindkey   '^[[1;5F' z4h-end-of-buffer              # ctrl+end
bindkey   '^[[1;3F' z4h-end-of-buffer              # alt+end
# Delete the character under the cursor.
bindkey   '^D'      delete-char                    # ctrl+d
bindkey   '^[[3~'   delete-char                    # delete
# Delete next word.
bindkey   '^[d'     z4h-kill-word                  # alt+d
bindkey   '^[D'     z4h-kill-word                  # alt+D
bindkey   '^[[3;5~' z4h-kill-word                  # ctrl+del
bindkey   '^[[3;3~' z4h-kill-word                  # alt+del
# Delete previous word.
bindkey   '^W'      z4h-backward-kill-word         # ctrl+w
bindkey   '^[^?'    z4h-backward-kill-word         # alt+bs
bindkey   '^[^H'    z4h-backward-kill-word         # ctrl+alt+bs

# Move cursor one zsh word forward.
bindkey   '^[[1;6C' z4h-forward-zword              # ctrl+shift+right
# Move cursor one zsh word backward.
bindkey   '^[[1;6D' z4h-backward-zword             # ctrl+shift+left
# Delete next zsh word.
bindkey   '^[[3;6~' z4h-kill-zword                 # ctrl+shift+del

# Delete line before cursor.
bindkey   '^[k'     backward-kill-line             # alt+k
bindkey   '^[K'     backward-kill-line             # alt+K
# Delete all lines.
bindkey   '^[j'     kill-buffer                    # alt+j
bindkey   '^[J'     kill-buffer                    # alt+J
# Push buffer to ephemeral history (won't be saved to HISTFILE) and delete all lines.
bindkey   '^[o'     z4h-stash-buffer               # alt+o
bindkey   '^[O'     z4h-stash-buffer               # alt+O
# Accept autosuggestion.
bindkey   '^[m'     z4h-autosuggest-accept         # alt+m
bindkey   '^[M'     z4h-autosuggest-accept         # alt+M
# Redo.
bindkey   '^[/'     redo                           # alt+/
# Expand alias/glob/parameter.
bindkey   '^ '      z4h-expand                     # ctrl+space
if (( _z4h_use[fzf-tab] )); then
  # Generic command completion.
  bindkey '^I'      z4h-fzf-complete               # tab
fi
if (( _z4h_use[fzf] )); then
  # Command history.
  bindkey '^R'      z4h-fzf-history                # ctrl+r
fi
# Show help for the command at cursor.
bindkey   '^[h'     run-help                       # alt+h
bindkey   '^[H'     run-help                       # alt+H
# Do nothing (better than printing '~').
bindkey   '^[[5~'   z4h-do-nothing                 # pageup
bindkey   '^[[6~'   z4h-do-nothing                 # pagedown

# Move cursor one word backward.
bindkey   '^[b'     z4h-backward-word              # alt+b
bindkey   '^[B'     z4h-backward-word              # alt+B
bindkey   '^[[1;3D' z4h-backward-word              # alt+left
bindkey   '^[[1;5D' z4h-backward-word              # ctrl+left

# Move cursor one word forward.
bindkey   '^[f'     z4h-forward-word               # alt+f
bindkey   '^[F'     z4h-forward-word               # alt+F
bindkey   '^[[1;3C' z4h-forward-word               # alt+right
bindkey   '^[[1;5C' z4h-forward-word               # ctrl+right

# cd into the previous directory.
bindkey   '^[[1;2D' z4h-cd-back                    # shift+left
# cd into the next directory.
bindkey   '^[[1;2C' z4h-cd-forward                 # shift+right
# cd into the parent directory.
bindkey   '^[[1;2A' z4h-cd-up                      # shift+up
if (( _z4h_use[fzf] )); then
  # cd into a subdirectory (interactive).
  bindkey '^[[1;2B' z4h-cd-down                    # shift+down
fi

if zstyle -T :z4h:bindkey macos-option-as-alt; then
  bindkey '∂'       z4h-kill-word                  # opt+d
  bindkey 'Î'       z4h-kill-word                  # opt+D
  bindkey '˚'       backward-kill-line             # opt+k
  bindkey '\uF8FF'  backward-kill-line             # opt+K
  bindkey '∆'       kill-buffer                    # opt+j
  bindkey 'Ô'       kill-buffer                    # opt+J
  bindkey 'ø'       z4h-stash-buffer               # opt+o
  bindkey 'Ø'       z4h-stash-buffer               # opt+O
  bindkey 'µ'       z4h-autosuggest-accept         # opt+m
  bindkey 'Â'       z4h-autosuggest-accept         # opt+M
  bindkey '÷'       redo                           # opt+/
  bindkey '˙'       run-help                       # opt+h
  bindkey 'Ó'       run-help                       # opt+H
  bindkey '∫'       z4h-backward-word              # opt+b
  bindkey 'ı'       z4h-backward-word              # opt+B
fi
