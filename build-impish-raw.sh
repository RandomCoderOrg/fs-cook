#!/usr/bin/env bash
#shellcheck disable=SC1091

# this is an example file to BUILD raw file system
# export variable SUITE to set debootstrap suite name (default: hirsute)

source plugins/envsetup
source plugins/colors

export OVERRIDER_COMPRESSION_TYPE
export SUITE
export ENABLE_EXIT

frn="out/impish-raw"
OVERRIDER_COMPRESSION_TYPE="gzip"
SUITE="impish"
ENABLE_EXIT=true

do_debootstrap "${frn}-arm64" arm64
do_compress    "${frn}-arm64"
do_debootstrap "${frn}-armhf" armhf
do_compress    "${frn}-armhf"
do_debootstrap "${frn}-amd64" amd64
do_compress    "${frn}-amd64"
