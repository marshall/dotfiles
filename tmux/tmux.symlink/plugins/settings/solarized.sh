#!/usr/bin/env bash
this_dir=$(cd "`dirname "$0"`"; pwd)

# base palette colors
base03="#002b36"
base02="#073642"
base01="#586e75"
base00="#657b83"
base0="#839496"
base1="#93a1a1"
base2="#eee8d5"
base3="#fdf6e3"
yellow="#b58900"
orange="#cb4b16"
red="#dc322f"
magenta="#d33682"
violet="#6c71c4"
blue="#268bd2"
cyan="#2aa198"
green="#859900"

# options
line_bg=$base02
empty_bg=$base03
active_bg=$blue
active_fg=$base3
inactive_bg=$line_bg
inactive_fg=$base1

right_sep=""
left_sep=""
win_left_sep=""
win_right_sep=""

main() {
  # status bar decorations
  prefix_color=$yellow
  session_bg=$green
  session_fg=$line_bg
  tmux set-option -g status-style "bg=$line_bg,fg=$base3"

  tmux set-option -g status-left-length 20
  tmux set-option -g status-left "#[bg=$session_bg,fg=$session_fg]#{?client_prefix,#[bg=$prefix_color],} #S "
  tmux set-option -ga status-left "#[fg=$session_bg,bg=$session_fg]#{?client_prefix,#[fg=$prefix_color],}${left_sep}"

  tiny_index="$this_dir/tiny_index.sh"
  window_index="#($tiny_index #I)"
  tmux set-window-option -g window-status-current-format "#[bg=$active_bg,fg=$line_bg]$left_sep"
  tmux set-window-option -ga window-status-current-format "#[fg=$active_fg,bg=$active_bg] #W#[fg=$line_bg]$window_index "
  tmux set-window-option -ga window-status-current-format "#[bg=$line_bg,fg=$active_bg]$left_sep"

  tmux set-window-option -g window-status-format "#[bg=$line_bg,fg=$base1] #W#[fg=$blue]$window_index"

  # status bar right sections

  # hostname
  host_script="$this_dir/host.sh"
  host_bg=$blue
  host_fg=$base3
  tmux set-option -g status-right "#[bg=$line_bg,fg=$host_bg] $right_sep#[fg=$host_fg,bg=$host_bg] #($host_script) #[bg=$host_bg,fg=$line_bg]$right_sep"

  # clock
  clock_bg=$green
  clock_fg=$empty_bg
  tmux set-option -ga status-right "#[bg=$line_bg,fg=$clock_bg]$right_sep#[fg=$clock_fg,bg=$clock_bg] %a %m/%d %R "

  # pane decorations
  tmux set-option -g pane-border-status top
  tmux set-option -g pane-border-format "#[align=right]#{?pane_active,#[fg=$active_bg],#[fg=$inactive_bg]}"
  tmux set-option -ga pane-border-format "$right_sep#{?pane_active,#[bg=$active_bg#,fg=$active_fg],#[bg=$inactive_bg#,fg=$inactive_fg]} "
  tmux set-option -ga pane-border-format "#{pane_title} #[bg=default]#{?pane_active,#[fg=$active_bg],#[fg=$inactive_bg]}$left_sep"

  tmux set-option -g pane-active-border-style "fg=$blue"

  tmux set-option -g pane-border-style "fg=$line_bg"

  # mode-style decoration
  tmux set-option -g mode-style "bg=$inactive_bg"

  # choose-tree decorations
  # modified from https://github.com/tmux/tmux/blob/1bf2f811ea8835dd24bdb773b5be4df517767d1f/window-tree.c#L39-L57

  tree_fmt=$(cat <<-END
		#{?pane_format,
			#{?pane_marked,#[reverse],}
			#{pane_current_command}#{?pane_active,*,}#{?pane_marked,M,}
			#{?#{&&:#{pane_title},#{!=:#{pane_title},#{host_short}}}, #[fg=$green]#{pane_title},}
		,
			#{?window_format,
				#{?window_marked_flag,#[reverse],}
				#[fg=$blue]#{window_name}#[fg=$base0]#{window_flags}
				#{?#{&&:#{==:#{window_panes},1},#{&&:#{pane_title},#{!=:#{pane_title},#{host_short}}}},: "#{pane_title}",}
			,
				#{session_windows} windows
				#{?session_grouped, 
					(group #{session_group}: 
					#{session_group_list}),
				}
				#{?session_attached, (attached),}
			}
		}
END
)

  tmux bind-key w choose-tree -Zw -F "$tree_fmt"
}

main
