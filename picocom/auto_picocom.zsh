# Wrap picocom so device automatically reconnects

auto_picocom() {
    until picocom $@; do
        echo "picocom disconnected, respawning.." >&2
        sleep 0.2
    done
}
