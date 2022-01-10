#!/usr/bin/env bash

source plugins/envsetup

export OVERRIDER_COMPRESSION_TYPE
export ENABLE_EXIT
export ENABLE_USER_SETUP

SUITE="hirsute"
frn="out/$SUITE-raw"
OVERRIDER_COMPRESSION_TYPE="gzip"
ENABLE_EXIT=true
ENABLE_USER_SETUP=false
PREFIX="${frn}"

additional_setup() {
    run_cmd echo deb $MIRROR $SUITE main restricted > /etc/apt/sources.list
    run_cmd echo deb-src $MIRROR $SUITE main restricted > /etc/apt/sources.list
    run_cmd echo deb $MIRROR $SUITE-updates multiverse > /etc/apt/sources.list
    run_cmd echo deb-src $MIRROR $SUITE-updates multiverser > /etc/apt/sources.list
}

do_build     "$PREFIX-arm64" arm64
do_build     "$PREFIX-armhf" armhf
do_build     "$PREFIX-amd64" amd64

do_compress  "$PREFIX-arm64"
do_compress  "$PREFIX-armhf"
do_compress  "$PREFIX-amd64"

do_unmount   "$PREFIX-arm64"
do_unmount   "$PREFIX-armhf"
do_unmount   "$PREFIX-amd64"

shout "setting up artifacts for GitHub"
msg "creating $SUITE-{arm64,amd64,armhf} directories"
mkdir -pv $SUITE-{arm64,amd64,armhf}

msg "copying tarballs to directories"
cp -rv $frn-arm64*tar* $SUITE-arm64
cp -rv $frn-armhf*tar* $SUITE-armhf
cp -rv $frn-amd64*tar* $SUITE-amd64

msg "calculating sha256sums"
sha256sum $frn-arm64*tar* > $SUITE-arm64/SHA256SUM
sha256sum $frn-armhf*tar* > $SUITE-arm64/SHA256SUM
sha256sum $frn-amd64*tar* > $SUITE-arm64/SHA256SUM

shout "done"
