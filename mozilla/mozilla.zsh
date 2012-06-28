
alias xpcom_uuidgen="uuidgen | tr '[[:upper:]]' '[[:lower:]]'"

MOZ_GIT_TOOLS=~/Source/moz-git-tools
export PATH=$PATH:$MOZ_GIT_TOOLS

bz_create_patch() {
  rev=HEAD^
  if [[ ( -n $1 ) && ( ! -f $1 ) ]]; then
    rev=$1
    shift
  fi

  git format-patch -k --no-stat --no-signature --stdout $rev -- $@ | git patch-to-hg-patch
}

export MOZILLA_CENTRAL=~/Code/mozilla-central
mozbuild() {
  cd $MOZILLA_CENTRAL
  make -f client.mk build $@
}

export MOZCONFIG_B2G_DESKTOP=$DOTFILES/mozilla/b2g_desktop.mozconfig
export MOZCONFIG_FIREFOX_DEBUG=$DOTFILES/mozilla/firefox_debug.mozconfig

mozbuild_b2g_desktop() {
  MOZCONFIG=$MOZCONFIG_B2G_DESKTOP mozbuild $@
}

mozbuild_firefox_debug() {
  MOZCONFIG=$MOZCONFIG_FIREFOX_DEBUG mozbuild $@
}
