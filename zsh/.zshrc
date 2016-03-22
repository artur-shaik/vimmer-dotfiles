ZSH=$HOME/.oh-my-zsh
ZSH_THEME="ash"
COMPLETION_WAITING_DOTS="true"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# snippet notify for long processes
bgnotify_threshold=6
function bgnotify_formatted {
    [ $1 -eq 0 ] && title="Success" || title="Failure"
    if whence notify-send > /dev/null; then
        notify-send $title "$2: after $3 s";
    fi
}

plugins=(mvn vi-mode git taskwarrior lol pip python suse web-search wd zsh-syntax-highlighting bgnotify)

source $ZSH/oh-my-zsh.sh

ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red
ZSH_HIGHLIGHT_STYLES[builtin]=none,bold
ZSH_HIGHLIGHT_STYLES[alias]=none,bold
ZSH_HIGHLIGHT_STYLES[function]=none,bold
ZSH_HIGHLIGHT_STYLES[command]=none,bold
ZSH_HIGHLIGHT_STYLES[hashed-command]=none,bold
ZSH_HIGHLIGHT_STYLES[precommand]=none
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[path_approx]=none

# Customize to your needs...
export PATH=/usr/lib/mpi/gcc/openmpi/bin:/home/ash/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:/usr/lib/mit/bin:/usr/lib/mit/sbin
fpath=($HOME/.zsh_completions $fpath)

autoload -U compinit
compinit

# vi mode bindings
bindkey -v
bindkey -a u undo
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins 'лл' vi-cmd-mode
bindkey -a '^R' redo
bindkey '^?' backward-delete-char               # fixing backspace in insert mode
bindkey -M viins '^[h' backward-delete-char     # alt-h to backspace single char in insert mode
bindkey '^[k' history-beginning-search-backward
bindkey '^[j' history-beginning-search-forward
bindkey -v '^[l' accept-line
bindkey -a '^[l' accept-line

[[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
[[ -z "$terminfo[kdch1]" ]] || bindkey -M viins "$terminfo[kdch1]" vi-delete-char
[[ -z "$terminfo[khome]" ]] || bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
[[ -z "$terminfo[khome]" ]] || bindkey -M viins "$terminfo[khome]" vi-beginning-of-line
[[ -z "$terminfo[kend]" ]] || bindkey -M vicmd "$terminfo[kend]" vi-end-of-line
[[ -z "$terminfo[kend]" ]] || bindkey -M viins "$terminfo[kend]" vi-end-of-line

bindkey '^[[5~' history-beginning-search-backward
bindkey '^[[6~' history-beginning-search-forward

bindkey '^[[7~' beginning-of-line 
bindkey '^[[8~' end-of-line

bindkey -M viins '^s' history-incremental-search-backward
bindkey -M vicmd '^s' history-incremental-search-backward

# right side prompt shows current mode. on every switch, change kbrd layout to us
function zle-line-init zle-keymap-select {
    VIM_PROMPT_NORMAL="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    VIM_PROMPT_INSERT="%{$fg_bold[white]%} -- INSERT --  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT_NORMAL}/(main|viins)/$VIM_PROMPT_INSERT} $EPS1"
    zle reset-prompt
    xkb-switch -s us
}
zle -N zle-line-init
zle -N zle-keymap-select

export KEYTIMEOUT=100

# show urgent (due) taskwarrior's tasks on init
if whence task > /dev/null; then
    task '+in and +PENDING' or +OVERDUE or due.before:3d or priority:H or pro:Study
    task active
fi

# show how much files that should be sorted
if [[ -d ~/INBOX ]]; then
    lsinbox=`ls ~/INBOX | wc -l`
    if [[ $lsinbox -gt 0  ]]; then
        print
        print "$fg_bold[red]Warning! INBOX has $lsinbox file(s)!$reset_color"
    fi
fi

# aliases
hi() { if [ -z "$*" ]; then history; else history | egrep "$@"; fi; }
alias gv='gwenview'
alias si='show_inbox'
alias tn='tasknext'
alias ta='task add'
alias c='clear'
alias vf='vifm'
alias vm='cmus'
alias tmux='tmux -2'
alias gs='git status'
alias vi='vim'
alias psg="ps aux | grep"
alias lslh='ls -hl'
alias lslha='ls -lha'
alias nb='newsbeuter'
alias qb='qutebrowser'
alias ytd='youtube-dl --write-sub --sub-lang "en,ru" -o "~/INBOX/%(title)s-%(id)s.%(ext)s"'
alias ipinfo="dig +short my.ip @outsideip.net"

#
# GTD task {{{1

alias in='task add +in'

tickle () {
    deadline=$1
    shift
    in +tickle wait:$deadline $@
}
ticklet () {
    id=$1
    deadline=$2
    shift
    task $id mod +tickle wait:$deadline
}
alias tick=tickle
alias tickt=ticklet
alias think='tickle 1d'
alias killl='kill -9 %1'

thinkt () {
    id=$1
    ticklet $id 1d
}

webpage_title (){
    wget -qO- $1 | awk 'BEGIN{IGNORECASE=1;FS="<title>|</title>";RS=EOF} {print $2}' | sed '/^$/d'
}

read_and_review (){
    link="$1"
    title=$(webpage_title $link)
    echo $title
    descr="\"Read and review: $title\""
    id=$(task add +rnr +in "$descr" | sed -n 's/Created task \(.*\)./\1/p')
    task "$id" annotate "$link"
}

alias rnr=read_and_review

# /GTD

trr() { echo "$@" | trans -u 'Mozilla/5.0' ru:en }
tre() { echo "$@" | trans -u 'Mozilla/5.0' en:ru }
mcd() { mkdir -p "$1"; cd "$1"; }
bkup() { cp "$1"{,.bak};}
whoisaddress() {whois $1 | grep -i -E "(address|country|city|state)" | sort | uniq}
ts() { args=$@; tmux send-keys -t right "$args" C-m }
rp() { pulseaudio -k; pulseaudio --start }
gmail() { curl -u "$1" --silent "https://mail.google.com/mail/feed/atom" | sed -e 's/<\/fullcount.*/\n/' | sed -e 's/.*fullcount>//'}
eraty() { raty $1 | elinks }
dbase64() { echo $@|base64 -d && echo }

transfer() { if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi 
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; } 

# foreground process with ctrl-z
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

export $(dbus-launch)
export DE=kde
export DISABLE_AUTO_TITLE=true

source ~/.profile
