# ash: промпт — starship (USE_STARSHIP пусто = вернуть p10k)
: "${USE_STARSHIP=1}"  # =1 по умолч.; USE_STARSHIP= zsh для p10k

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -z $USE_STARSHIP && -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(\cat ~/.cache/wal/sequences &)


ZSH_DISABLE_COMPFIX=true
ZSH=$HOME/.oh-my-zsh
zstyle ':omz:update' frequency 14
[[ -n $USE_STARSHIP ]] && ZSH_THEME="" || ZSH_THEME="powerlevel10k/powerlevel10k"
COMPLETION_WAITING_DOTS="true"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# snippet notify for long processes
bgnotify_threshold=6
function bgnotify_formatted {
    [ $1 -eq 0 ] && title="Success" || title="Failure"
    if whence notify-send > /dev/null; then
        DISPLAY=:0 notify-send $title "$2: after $3 s";
    fi
}

plugins=(fzf-tab zsh-vi-mode git taskwarrior timewarrior pip python suse web-search wd zsh-syntax-highlighting bgnotify)

fpath=($HOME/.zsh_completions $fpath)

source $ZSH/oh-my-zsh.sh

# ash: zsh-vi-mode на КАЖДЫЙ accept-line зовёт zvm_zle-line-finish ->
# zvm_set_cursor -> DECSCUSR reset "\e[0 q". ZVM гейтит это только на $VIMRUNTIME,
# а nvim :terminal ставит $NVIM (не VIMRUNTIME) -> escape течёт, в буфер "0 q".
# Глушим единственный choke-point внутри редактор-терминала (zvm_set_cursor
# определён при source oh-my-zsh.sh выше, переопределение держится).
if [[ -n "$NVIM" || -n "$VIM" || -n "$VIM_TERMINAL" ]]; then
  ZVM_CURSOR_STYLE_ENABLED=false
  zvm_set_cursor() {}
fi

# ash: держать compiled-дамп свежим (новые completions инвалидируют dump,
# без .zwc compinit парсит текстом каждый старт — было 3.5с vs 1.0с)
() {
  local d=${ZSH_COMPDUMP:-$HOME/.zcompdump-$HOST-$ZSH_VERSION}
  [[ -f $d && ( ! -f $d.zwc || $d -nt $d.zwc ) ]] && zcompile -R -- $d.zwc $d 2>/dev/null
}

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

ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_CURSOR_STYLE_ENABLED=false

# Customize to your needs...
export PATH=/usr/lib/mpi/gcc/openmpi/bin:/home/ash/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:/usr/lib/mit/bin:/usr/lib/mit/sbin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH

# vi mode bindings
bindkey -v
bindkey -a u undo
bindkey -M viins '^H' backward-delete-char
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

precmd () {
    jobscount=$(($(jobs --rp | wc -l) + $(jobs --sp | wc -l)))
    if [[ $jobscount -eq 0 ]]; then 
        jobscount=; 
    else
        jobscount="$jobscount » "
    fi
}
setopt prompt_subst
PS1+='${jobscount}'

export KEYTIMEOUT=100

# show urgent (due) taskwarrior's tasks on init
#if whence show_inbox > /dev/null; then
#    show_inbox
#fi

# aliases
hi() { if [ -z "$*" ]; then history; else history | egrep "$@"; fi; }
tasknext() {task next "$@" | head -n 8}
tin() {
    clear
    task "$(taskinfilter.sh)" minimal "$@"
    task active "$@"
    # todo list -s NEEDS-ACTION personal family-cases
}
alias si='show_inbox'
alias tn='tasknext'
alias ta='task add'
alias to='taskopen'
alias c='clear'
alias vf='vifm'
alias tmux='tmux -2'
alias gs='git status'
alias vi='nvim'
alias vim='nvim'
alias psg="ps aux | grep"
alias ls='lsd --color=never'
alias l='ls -la'
alias lsl='ls -l'
alias lsla='ls -la'
alias news='newsboat -C ~/.newsboat/ttrss-admin'
alias newssocial='newsboat -C ~/.newsboat/ttrss-social'
alias qb='qutebrowser'
alias ytdbest='yt-dlp --write-sub --sub-lang "en,ru" -o "~/INBOX/%(title)s-%(id)s.%(ext)s"'
alias myip="curl ipinfo.io/ip"
alias ipinfo="curl ipinfo.io/$1"
alias killl='kill -9 %1'
alias mux='tmuxinator'
alias rm='trash-put'
alias git=hub
alias vimdev='VIM_ENV=dev nvim'
alias vimwriter='VIM_ENV=writer nvim'
alias vimwiki='VIM_ENV=wiki nvim -c "VimwikiIndex"'
alias mpc='mpc -h $(cat $HOME/.mpd_host) -p $(cat $HOME/.mpd_port)'
alias timer='termdown -f big'
alias upload='rsync --chmod=F664 -zvhP --stats'
alias down='aria2c -d ~/INBOX/'
alias mutt='neomutt'
alias cat='bat --theme GitHub'
alias pythonref='xdg-open "/home/ash/Nextcloud/books/разработка программирование технологии/python/The Python Quick Syntax Reference [PDF] [StormRG]/Python Quick Syntax Reference, The - Walters, Gregory.pdf"'
alias weather-bishkek='curl "wttr.in/bishkek?F"'
alias qr="curl qrenco.de/$1"
alias nsxiv="nsxiv -a"
alias sgptcl="xclip -o -sel clipboard | sgpt $@"

vimsession () {
    VIM_ENV=dev nvim -c ":OpenSession! $1"
}

fzfc() {
    curl -ks cht\.sh/$(
        curl -ks cht\.sh/:list | \
        IFS=+ fzf --preview 'curl -ks http://cht.sh{}' -q "$*");
}

listen-to-yt() { 
    if [[ -z "$1" ]]; then 
        echo "Enter a search string!"; 
    else 
        mpv "$(yt-dlp --default-search 'ytsearch1:' \"$1\" --get-url | tail -1)"; 
    fi
}

tov() {
    fzfytdh.sh --open "$(t $1 export | jq '.[] | .annotations | .[] | .description' | sed 's/\\//g' | sed -E 's/"(.*)"/\1/g')"
}

#
# GTD task {{{1

alias in='task add +in'

today () {
    if [[ $# -eq 0 ]]; then
        task +today minimal
    elif [[ $1 == "next" ]]; then
        task +today next
    else
        id=$1
        task $id mod +today
    fi
}

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

# done for today
dft () {
    id=$1
    task $id mod -today
    ticklet $id tomorrow
}

week() {
    task $1 mod wait:1w
}

webpage_title (){
    wget -qO- $1 | awk 'BEGIN{IGNORECASE=1;FS="<title>|</title>";RS=EOF} {print $2}' | sed '/^$/d'
}

read_and_review (){
    link="$1"
    title=$(webpage_title $link)
    echo $title
    descr="\"Read and review: $title\""
    id=$(task add +rnr +in "$descr" "($@)" | sed -n 's/Created task \(.*\)./\1/p')
    task "$id" annotate "$link"
}
alias rnr=read_and_review

ta_link () {

    if [ "$#" -lt 2 ]; then
      echo "Usage: $0 link tw_parameters"
    else
        link="$1"
        shift
        title=$(webpage_title $link)
        echo $title
        id=$(task add "[$title]" "$@" +link | sed -n 's/Created task \(.*\)./\1/p')
        echo "Created task $id"
        task "$id" annotate "$link"
    fi

}

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

# buku wrappers
bma() {
    link=$1
    shift
    buku -a "$link" $@
}
bms() { buku --deep -s $@ }
bmo() { buku -o $@ }
# /buku

transfer() { if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi 
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; } 

#tws() {
#    echo "TW Done:$(task count end.after:today) Due:$(task count +DUE) Overdue:$(task count +OVERDUE) Next:$(task count +next)"
#}

function blog-new {
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 [post-slug]"
    else
        cd ~/projects/shaik.link/
        hugo server -D &> blog.log &
        sleep 3s

        hugo new posts/$1/

        xdg-open http://localhost:1313/posts/$1/

        vimwriter -c ':tabnew' -c ':call termopen("tail -f blog.log")' -c ':tabnext' -O content/posts/$1/index.md content/posts/$1/index.ru.md

        pkill hugo
        rm blog.log
    fi
}

function blog-new-redirect {
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 [post-slug]"
    else
        cd ~/projects/shaik.link/

        hugo new redirect/$1.md

        vimwriter content/redirect/$1.md
    fi
}

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

#export $(dbus-launch)
export DE=generic
export DISABLE_AUTO_TITLE=true

source ~/.profile
source /home/ash/Soft/git-flow-completion/git-flow-completion.zsh

export PATH="$HOME/.rbenv/bin:$PATH"

[[ -s /home/ash/.autojump/etc/profile.d/autojump.sh ]] && source /home/ash/.autojump/etc/profile.d/autojump.sh



if [[ $1 == eval ]]
then
    "$@" >> /dev/null
set --
fi

if [[ -n $USE_STARSHIP ]]; then
  eval "$(starship init zsh)"
else
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

# sdkman: ленивая загрузка (init ~0.5с). PATH к current-кандидатам — статично,
# так что java/mvn работают сразу; сам sdkman-init грузится при первом вызове sdk.
export SDKMAN_DIR="/home/ash/.sdkman"
for _c in "$SDKMAN_DIR"/candidates/*/current/bin(N); do
    PATH="$_c:$PATH"
done
unset _c
sdk() {
    unfunction sdk
    [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
    sdk "$@"
}

# opam configuration
[[ ! -r /home/ash/.opam/opam-init/init.zsh ]] || source /home/ash/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
export PATH=$PATH:$HOME/.local/bin

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/ash/.lmstudio/bin"
# End of LM Studio CLI section

# nvm: ленивая загрузка (~0.7с). PATH к default-ноде — статично (node/npm/npx/claude
# работают сразу); сам nvm.sh грузится при первом вызове nvm.
export NVM_DIR="$HOME/.config/nvm"
if [[ -r "$NVM_DIR/alias/default" ]]; then
    _nvm_default=$(<"$NVM_DIR/alias/default")
    _nvm_bin=$(echo "$NVM_DIR/versions/node/v${_nvm_default#v}"*/bin(N[1]))
    [[ -d "$_nvm_bin" ]] && PATH="$_nvm_bin:$PATH"
    unset _nvm_default _nvm_bin
fi
nvm() {
    unfunction nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}

# mcfly (fuzzy-поиск по истории, ^R) — В КОНЦЕ: omz и кастом-биндинги
# затирали его ^R, когда init стоял в начале файла
export MCFLY_FUZZY=2
export MCFLY_RESULTS=30
# export MCFLY_KEY_SCHEME=vim  # выключен: внутри TUI удобнее emacs-комбо
# zsh-vi-mode инициализируется на первом промпте и перетирает биндинги —
# mcfly подключаем через его хук (+ сразу, если ZVM вдруг отключат)
zvm_after_init_commands+=('eval "$(mcfly init zsh)"')
eval "$(mcfly init zsh)"
