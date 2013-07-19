autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

git_branch() {
  echo $(git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$(git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    echo -n "%{$fg_bold[green]%}[$(git_prompt_info)%{$reset_color%}"
    echo $st | grep "nothing to commit" 1>/dev/null 2>/dev/null
    if [[ "$?" != "0" ]]
    then
      echo -n "%{$fg_bold[red]%} *%{$reset_color%}"
    fi
    echo "%{$fg_bold[green]%}]%{$reset_color%}"
  fi
}

git_prompt_info() {
 ref=$(git symbolic-ref HEAD 2>/dev/null) || return
 echo "${ref#refs/heads/}"
}

hg_prompt_info() {
    hg prompt --angle-brackets "%{$fg_bold[green]%}[<branch>@<tags|,>]%{$reset_color%}" 2>/dev/null
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

export PROMPT=$'$(user_at_host) $(current_time) $(current_dir) $(git_dirty)\n$(venv_info)$(prompt_chars) '
export RPROMPT='$(vi_mode_prompt_info)'

precmd() {
  title "zsh" "%m" "%55<...<%~"
}
