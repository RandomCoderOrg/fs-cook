#!/usr/bin/env bash

# sudo check
if [ "$(uname -o)" = "Android" ]; then
    echo "Running in Termux"
    apt update 
    apt install debootstrap which proot -y 
else 
    if [ "$(id -u)" != "0" ]; then
        if ! command -v sudo >/dev/null 2>&1; then
            echo "This script requires sudo or root privileges but none present."
            exit 1
        else
            SUDO="$(command -v sudo)"
        fi
    fi
    $SUDO apt update 
    $SUDO apt install -y qemu-user-static binfmt-support 
fi
