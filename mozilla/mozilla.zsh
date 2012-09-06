export MOZILLA_CENTRAL=~/Code/mozilla-central
export MOZILLA_INBOUND=~/Code/mozilla-inbound
export MOZILLA_CENTRAL_HG=~/Code/mozilla-central-hg

alias xpcom_uuidgen="uuidgen | tr '[[:upper:]]' '[[:lower:]]'"

MOZ_GIT_TOOLS=~/Source/moz-git-tools
export PATH=$PATH:$MOZ_GIT_TOOLS:$DOTFILES/mozilla

bz_format_patch() {
  git format-patch -k --no-stat --no-signature --stdout $@ | git patch-to-hg-patch
}

bz_create_patch() {
  rev=HEAD^
  if [[ ( -n "$1" ) && ( ! -f "$1" ) ]]; then
    rev=$1
    shift
  fi

  bz_format_patch $rev -- $@
}

git_commit_to_hg_patch_mc() {
  git_commit_to_hg_patch $MOZILLA_CENTRAL_HG $@
}

git_commit_to_hg_patch_inbound() {
  git_commit_to_hg_patch $MOZILLA_INBOUND $@
}

moz_try_git_commit() {
  git_commit_to_hg_patch $MOZILLA_CENTRAL_HG $@
  hg -R $MOZILLA_CENTRAL_HG trychooser
}

git_commit_to_hg_patch() {
  if [[ "$1" = "--help" ]]; then
    echo "Usage: git_commit_to_hg_patch (hg repo) (revisions)"
    echo "  hg repo: path to a HG repository ($MOZILLA_CENTRAL_HG is default)"
    echo "  revisions: revision(s) suitable for git format-patch (HEAD^..HEAD is default)"
    return
  fi

  REPO=$MOZILLA_CENTRAL_HG
  if [[ "$1" != "" ]]; then
    REPO=$1
    shift
  fi

  REVS="HEAD^"
  if [[ "$1" != "" ]]; then
    REVS=$@
  fi

  echo "Creating MQ patch in HG repo: $REPO"
  echo "Using revision(s): $REVS"

  hg -R $REPO pull -u
  git_branch=$(git branch | grep '*' | sed 's/* //')
  bz_create_patch $REVS | hg -R $REPO qimport --git --name $git_branch --push -
}

moz_git_push_inbound() {
  if [[ ( "$1" == "-t" ) || ( "$1" == "--tip" ) ]]; then
    ARGS=--tip $MOZILLA_INBOUND
  else
    ARGS=$MOZILLA_INBOUND
  fi

  # hub won't work
  unalias git
  /usr/local/bin/git push-to-hg $ARGS $@
}

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
