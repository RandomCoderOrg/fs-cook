#!/usr/bin/env bash
#shellcheck disable=SC1091

# this is an example file to BUILD raw file system
# export variable SUITE to set debootstrap suite name (default: hirsute)

source plugins/envsetup
source plugins/colors

do_debootstrap "out/hirsute-arm64" "arm64"
do_compress "out/hirsute-arm64"
