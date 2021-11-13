#!/usr/bin/env bash

# sudo check
if [ "$(id -u)" != "0" ]; then
    if ! command -v sudo >/dev/null 2>&1; then
        echo "This script requires sudo or root privileges but none present."
        exit 1
    else
        SUDO="$(command -v sudo)"
    fi
fi

deps="qemu-user-static binfmt-support"

$SUDO apt install -y "$deps"
