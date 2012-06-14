
alias xpcom_uuidgen="uuidgen | tr '[[:upper:]]' '[[:lower:]]'"

MOZ_GIT_TOOLS=~/Source/moz-git-tools
export PATH=$PATH:$MOZ_GIT_TOOLS

bz_create_patch() {
  rev=HEAD^
  if [ "$1" != "" ]; then
    rev=$1
  fi

  git format-patch -k --no-stat --no-signature $rev --stdout | git patch-to-hg-patch
}
