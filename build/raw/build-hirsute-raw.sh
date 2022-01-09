#!/usr/bin/env bash
#shellcheck disable=SC1091

# this is an example file to BUILD raw file system
# export variable SUITE to set debootstrap suite name (default: hirsute)

source plugins/envsetup
source plugins/colors

export OVERRIDER_COMPRESSION_TYPE
export ENABLE_EXIT
export FS_USER
export FS_PASS

frn="out/hirsute-raw"
OVERRIDER_COMPRESSION_TYPE="gzip"
ENABLE_EXIT=true

do_build "${frn}-arm64" arm64
do_compress    "${frn}-arm64"
do_build "${frn}-armhf" armhf
do_compress    "${frn}-armhf"
do_build "${frn}-amd64" amd64
do_compress    "${frn}-amd64"
