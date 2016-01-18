## Link this file to ~/.oh-my-zsh/themes

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%} ❢"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function tasks_num {
    if whence task > /dev/null; then
        echo %K{blue}%{$FX[bold]%}%{$fg[white]%}\[ `task +in status:pending count` \]%{$reset_color%}%K{yellow}%{$fg[blue]%}
    fi
}

PROMPT='%{$(tasks_num)%}╼ %{$FX[bold]%}%{$fg[white]%}% [%*] %{$reset_color%}%K{blue}%{$fg[yellow]%} %{$FX[bold]%}%{$fg[white]%}%~ %{$reset_color%}%{$fg[blue]%}$(git_prompt_info)
 %(?,%{$fg[green]%}✔,%{$fg[red]%}✘) %{$reset_color%}» '
