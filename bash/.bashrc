test -s ~/.alias && . ~/.alias || true

stty -ixon

# enable vim-like bindings in bash
set -o vi
bind '"\e[6~": history-search-forward'
bind '"\e[5~": history-search-backward'
bind '"\ej": history-search-forward'
bind '"\ek": history-search-backward'
bind -m vi-command '"\el" "\r"'
bind -m vi-insert '"\el" "\r"'
bind -m vi-insert '"jk" "\e"'
