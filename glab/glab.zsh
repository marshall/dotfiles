glab_clone_tree () {
  group="$1"
  top_level=${2:-$HOME/Code}
  echo "Cloning '$group' with root at '$top_level'"

  pushd "$top_level"
  glab repo clone -g "$group" -p --paginate
  popd
}
