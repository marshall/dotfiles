#!/usr/bin/env bash
this_dir=$(
	cd "$(dirname "$0")"
	pwd
)

# catppuccin mocha colors
thm_bg="#1e1e2e"
thm_fg="#cdd6f4"
thm_cyan="#89dceb"
thm_black="#181825"
thm_gray="#313244"
thm_magenta="#cba6f7"
thm_pink="#f5c2e7"
thm_red="#f38ba8"
thm_green="#a6e3a1"
thm_yellow="#f9e2af"
thm_blue="#89b4fa"
thm_orange="#fab387"
thm_black4="#585b70"

# options
line_bg=$thm_black
empty_bg=$thm_black

# active window / pane
active_bg=$thm_blue
active_fg=$thm_black
active_idx_fg=$thm_bg

# inactive window / pane
inactive_bg=$thm_black
inactive_fg=$thm_fg
inactive_idx_fg=$thm_yellow

# status bar decorations
prefix_color=$thm_yellow
session_bg=$thm_green
session_fg=$line_bg
session_prefix=" "

# hostname
host_script="$this_dir/host.sh"
host_bg=$thm_blue
host_fg=$thm_black

# clock
clock_bg=$thm_green
clock_fg=$empty_bg

right_sep=""
left_sep=""
win_left_sep=""
win_right_sep=""

main() {
	tmux set-option -g status-style "bg=$line_bg,fg=$thm_green"

	tmux set-option -g status-left-length 20
	tmux set-option -g status-left "#[bg=$session_bg,fg=$session_fg,bold]#{?client_prefix,#[bg=$prefix_color],} $session_prefix#S "
	tmux set-option -ga status-left "#[fg=$session_bg,bg=$session_fg]#{?client_prefix,#[fg=$prefix_color],}${left_sep}"

	tiny_index="$this_dir/tiny_index.sh"
	window_index="#($tiny_index #I)"
	tmux set-window-option -g window-status-current-format "#[bg=$active_bg,fg=$line_bg]$left_sep"
	tmux set-window-option -ga window-status-current-format "#[fg=$active_fg,bg=$active_bg,bold] #W#[fg=$active_idx_fg]$window_index "
	tmux set-window-option -ga window-status-current-format "#[bg=$line_bg,fg=$active_bg]$left_sep"

	tmux set-window-option -g window-status-format "#[bg=$line_bg,fg=$inactive_fg] #W#[fg=$inactive_idx_fg]$window_index"

	# status bar right sections
	tmux set-option -g status-right "#[bg=$line_bg,fg=$host_bg] $right_sep#[fg=$host_fg,bg=$host_bg,bold] #($host_script) #[bg=$host_bg,fg=$line_bg,nobold]$right_sep"
	tmux set-option -ga status-right "#[bg=$line_bg,fg=$clock_bg]$right_sep#[fg=$clock_fg,bg=$clock_bg] %a %m/%d %R "

	# pane decorations
	tmux set-option -g pane-border-status top
	tmux set-option -g pane-border-format "#[align=right]#{?pane_active,#[fg=$active_bg],#[fg=$inactive_bg]}"
	tmux set-option -ga pane-border-format "$right_sep#{?pane_active,#[bg=$active_bg#,fg=$active_fg],#[bg=$inactive_bg#,fg=$inactive_fg]} "
	tmux set-option -ga pane-border-format "#{pane_title} #[bg=default]#{?pane_active,#[fg=$active_bg],#[fg=$inactive_bg]}$left_sep"

	tmux set-option -g pane-active-border-style "fg=$thm_blue"

	tmux set-option -g pane-border-style "fg=$line_bg"

	# mode-style decoration
	tmux set-option -g mode-style "bg=$thm_gray"

	# choose-tree decorations
	# modified from https://github.com/tmux/tmux/blob/1bf2f811ea8835dd24bdb773b5be4df517767d1f/window-tree.c#L39-L57

	IFS='' read -r -d '' tree_fmt <<END
		#{?pane_format,
			#{?pane_marked,#[bg=$active_bg],}
			#{pane_current_command}#{?pane_active,*,}#{?pane_marked,M,}
			#{?#{&&:#{pane_title},#{!=:#{pane_title},#{host_short}}}, #[fg=$thm_green]#{pane_title},}
		,
			#{?window_format,
				#{?window_marked_flag,#[bg=$active_bg],}
				#[fg=$thm_blue]#{window_name}#[fg=$thm_black4]#{window_flags}
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

	tmux bind-key w choose-tree -Zw -F "$tree_fmt"
}

main
