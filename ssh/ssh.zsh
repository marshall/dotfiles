setup_ssh_agent() {
  # Try to find an existing ssh-agent before starting a new one
  agent_pid=$(ps -ef | grep "ssh-agent" | grep -v "grep" | awk '{print $2}')

  if [[ -z $agent_pid ]]; then
    # None exists, start ssh-agent
    eval "$(ssh-agent)"
  else
    agent_ppid=$(ps -ef | grep "ssh-agent" | grep -v "grep" | awk '{print $3}')
    agent_sock=$(find /tmp -path "*ssh*" -type s -iname "agent.$agent_ppid" 2>/dev/null)
    echo "[ssh-agent] PID: $agent_pid, Sock: $agent_sock"
    export SSH_AGENT_PID="$agent_pid"
    export SSH_AUTH_SOCK="$agent_sock"
  fi

  known_keys=$(ssh-add -l | awk '{print $3}')
  "$DOTFILES/ssh/identity_files.awk" "$HOME/.ssh/config" | sort -u | while read key; do
    case "$key" in
        "~/"*) key="${HOME}/${key#"~/"}";;
    esac

    if [[ -f "$key" ]]; then
        # Only ssh-add unknown identity files
        (echo $known_keys | grep $key > /dev/null) && continue

        echo "$fg[white]Adding ssh key $reset_color$fg[blue]$key$reset_color"
        ssh-add $key
    fi
  done
}

if [[ "$OS_NAME" = "Linux" ]]; then
  setup_ssh_agent
fi
