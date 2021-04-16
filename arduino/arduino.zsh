if [ "$OS_NAME" = "Darwin" ]; then
    export ARDUINO_ROOT=/Applications/Arduino.app/Contents/Resources/Java
fi

export ARDUINO_TOOLS_AVR=$ARDUINO_ROOT/hardware/tools/avr
export ARDUINO_TOOLS_ARM=$ARDUINO_ROOT/hardware/tools/g++_arm_none_eabi

_path_append "$ARDUINO_TOOLS_AVR/bin" "$ARDUINO_TOOLS_ARM/bin"
