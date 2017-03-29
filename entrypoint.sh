#!/bin/bash

# Detect ip and forward ADB ports outside to outside interface
ip=$(ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
socat tcp-listen:5037,bind=$ip,fork tcp:127.0.0.1:5037 &
socat tcp-listen:5554,bind=$ip,fork tcp:127.0.0.1:5554 &
socat tcp-listen:5555,bind=$ip,fork tcp:127.0.0.1:5555 &

EMULATOR="android-25"
ARCH="arm"

echo "no" | ${ANDROID_HOME}/tools/android create avd -f -n test --target android-25 --tag google_apis
${ANDROID_HOME}/tools/emulator64-arm -avd test -noaudio -no-window -gpu off -verbose -qemu
