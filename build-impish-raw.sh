#!/usr/bin/env bash
#shellcheck disable=SC1091

# this is an example file to BUILD raw file system
# export variable SUITE to set debootstrap suite name (default: hirsute)

source plugins/envsetup
source plugins/colors

export OVERRIDER_COMPRESSION_TYPE
export SUITE
export ENABLE_EXIT
export ENABLE_USER_SETUP

frn="out/impish-raw"
OVERRIDER_COMPRESSION_TYPE="gzip"
SUITE="impish"
ENABLE_EXIT=true
ENABLE_USER_SETUP=false

additional_setup() {
    shout "additional_setup"
    run_cmd echo deb http://archive.ubuntu.com/ubuntu/ focal main restricted \> /etc/apt/sources.list
    run_cmd echo deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted \> /etc/apt/sources.list
    run_cmd echo deb http://archive.ubuntu.com/ubuntu/ focal-updates universe \> /etc/apt/sources.list
    run_cmd echo deb-src http://archive.ubuntu.com/ubuntu/ focal-updates universe \> /etc/apt/sources.list
    run_cmd echo deb http://archive.ubuntu.com/ubuntu/ focal multiverse \> /etc/apt/sources.list
    run_cmd echo deb-src http://archive.ubuntu.com/ubuntu/ focal multiverse \> /etc/apt/sources.list

    run_cmd "apt-get update"

    install_pkg "lz4 bzip2 gzip bc pv"
}

do_build "${frn}-arm64" arm64
do_compress    "${frn}-arm64"
do_build "${frn}-armhf" armhf
do_compress    "${frn}-armhf"
do_build "${frn}-amd64" amd64
do_compress    "${frn}-amd64"

do_unmount "${frn}-arm64"
do_unmount "${frn}-armhf"
do_unmount "${frn}-amd64"
