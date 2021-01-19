white='#f8f8f2'
gray='#44475a'
dark_gray='#282a36'
light_purple='#bd93f9'
dark_purple='#6272a4'
cyan='#8be9fd'
green='#50fa7b'
orange='#ffb86c'
red='#ff5555'
pink='#ff79c6'
yellow='#f1fa8c'

right_sep=""
left_sep=""

get_tmux_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-option -gqv "$option")
  if [ -z $option_value ]; then
    echo $default_value
  else
    echo $option_value
  fi
}

right_section() {
  BG=${BG:-$orange}
  FG=${FG:-$dark_gray}
  script=$1

  str="#[fg=$BG,bg=$gray,nobold,nounderscore,noitalics] $right_sep"
  str+="#[fg=$FG,bg=$BG] #($script)"

  # #[fg=#8be9fd,bg=#44475a,nobold,nounderscore,noitalics] 
  #str+="#[fg=$gray,bg=$BG,nobold,nounderscore,noitalics] $right_sep"

  # sed/regex to get the colors right
  regex="^#\[fg=(#[0-9a-f]+),bg=(#[0-9a-f]+),(.+)\]"
  replacement="#[fg=\\1,bg=$BG,\\3]"

  status_right=$(get_tmux_option status-right "" | sed -E "s/$regex/$replacement/")

  tmux set-option -g status-right "$str$status_right"
}
