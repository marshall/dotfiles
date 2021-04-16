_path_append "$HOME/.cargo/bin"

cargo_target() {
    # set the default target at the project level
    project_dir=$(dirname "`cargo locate-project | jq -r '.root'`")
    if [[ $? != 0 ]]; then
       return 1;
    fi

    config_dir="$project_dir/.cargo"
    config="$config_dir/config"

    if [[ -f "$config" ]]; then
         data=`remarshal -if toml -of json "$config" | jq ". * {build: {target: \"$1\"}}"`
    else
        if [[ ! -d "$config_dir" ]]; then
            mkdir -p "$config_dir"
        fi
        data=`jq -n "{build: {target: \"$1\"}}"`
    fi

    echo $data | remarshal -if json -of toml > "$config"
}
