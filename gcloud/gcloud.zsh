GCLOUD_SDK=$HOME/Apps/google-cloud-sdk

# The next line updates PATH for the Google Cloud SDK.
_path_append "$GCLOUD_SDK/bin"

# The next line enables shell command completion for gcloud.
if [ -f "$GCLOUD_SDK/completion.zsh.inc" ]; then . "$GCLOUD_SDK/completion.zsh.inc"; fi
