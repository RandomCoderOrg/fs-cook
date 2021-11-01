#!/usr/bin/env bash
#shellcheck disable=SC1091

# this is an example file to BUILD raw file system
# export variable SUITE to set debootstrap suite name (default: hirsute)

source plugins/envsetup
source plugins/colors

#do_debootstrap "out/hirsute-armhf" "armhf"
#do_compress "out/hirsute-armhf"

export SUITE="impish"

do_debootstrap "out/impish-arm64" "arm64"
do_compress "out/impish-arm64"

do_debootstrap "out/impish-armhf" "armhf"
do_compress "out/impish-armhf"

do_debootstrap "out/impish-amd64" "amd64"
do_compress "out/impish-amd64"
