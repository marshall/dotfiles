if [ "$OS_NAME" = "Darwin" ]; then
    if [[ -d $HOME/Library/Android/sdk ]]; then
        export ANDROID_SDK=$HOME/Library/Android/sdk
    else
        export ANDROID_SDK=$HOME/Applications/android-sdk-macosx
    fi
elif [ "$OS_NAME" = "Linux" ]; then
    export ANDROID_SDK=$HOME/Apps/android-sdk-linux
fi

export ANDROID_HOME=$ANDROID_SDK
export ANDROID_SOURCE=$HOME/Source/android
export NDK_CCACHE=/usr/local/bin/ccache

export PATH=$PATH:$ANDROID_SDK/platform-tools:$ANDROID_SDK/tools:$DOTFILES/android

# This makes AOSP build happier in Mac OS X
ulimit -S -n 1024

# Use logcat-color
alias logcat=$ZSH/android/logcat-color/logcat-color
