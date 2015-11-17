## Link this file to ~/.oh-my-zsh/themes

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function tasks_num {
    if whence task > /dev/null; then
        echo \[%{$FX[bold]%}%{$FG[229]%} `task +in status:pending count` %{$reset_color%}\]
    fi
}

PROMPT='%(?, ,%{$fg[red]%}FAIL%{$reset_color%})
╭%{$(tasks_num)%}╼ %{$FG[147]%}%n%{$reset_color%}: %{$FX[bold]$FG[153]%}%~%{$reset_color%}$(git_prompt_info) 
╰╼ '

RPROMPT='%{$FG[151]%}[%*]%{$reset_color%}'
