autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

git_branch() {
    echo $(git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
    st=$(git status --porcelain 2>/dev/null)
    if [[ "$?" != "0" ]]; then
        return
    fi

    echo -n "%{$fg_bold[green]%}[$(git_prompt_info)%{$reset_color%}"

    if [[ "$st" != "" ]]; then
        echo -n "%{$fg_bold[red]%} *%{$reset_color%}"
    fi

    echo "%{$fg_bold[green]%}]%{$reset_color%}"
}

git_prompt_info() {
   ref=$(git symbolic-ref HEAD 2>/dev/null) || return
   echo "${ref#refs/heads/}"
}

hg_prompt_info() {
   hg prompt --angle-brackets "%{$fg_bold[green]%}[<branch>@<tags|,>]%{$reset_color%}" 2>/dev/null || return
}

venv_info() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo -n "%{$fg_bold[green]%}[venv:%{$reset_color%}"
        echo -n "%{$fg[white]%}`basename "$VIRTUAL_ENV"`%{$reset_color%}"
        echo "%{$fg_bold[green]%}] "
    fi
}

current_dir() {
    echo "%{$fg[white]%}[%~]%{$reset_color%}"
}

user_at_host() {
    echo "%{$fg_bold[green]%}%n@%m%{$reset_color%}"
}

current_time() {
    echo "%{$fg[blue]%}%D{[%I:%M:%S]}%{$reset_color%}"
}

prompt_chars() {
    echo "%{$fg[blue]%}->%{$fg_bold[blue]%} %#%{$reset_color%}"
}

export PROMPT=$'$(user_at_host) $(current_time) $(current_dir) $(git_dirty)$(hg_prompt_info)\n$(venv_info)$(prompt_chars) '
export RPROMPT='$(vi_mode_prompt_info)'

marshall_precmd() {
    title "zsh" "%m" "%55<...<%~"
}


typeset -a precmd_functions
precmd_functions+=marshall_precmd
