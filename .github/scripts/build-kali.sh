#!/usr/bin/env bash
#shellcheck disable=SC1091

# this is an example file to BUILD raw file system
# export variable SUITE to set debootstrap suite name (default: hirsute)

################
# kali build notice
# for best results use kali-linux host for building
# or try running with docker file in build/kali/raw

source plugins/envsetup
source plugins/colors

export OVERRIDER_COMPRESSION_TYPE
export ENABLE_EXIT
export SUITE
export OVERRIDER_MIRROR
export INCLUDE_PACKAGES
export DISABLE_LOCAL_DEBOOTSTRAP
export ENABLE_USER_SETUP
# export FS_USER
# export FS_PASS

SUITE="kali-rolling"
# FS_USER="kali"
# FS_PASS="kali" # no need to sepecify FS_UID & FS_GID cause default is 1001
OVERRIDER_MIRROR="http://http.kali.org/kali"
frn="out/${SUITE}-big"
INCLUDE_PACKAGES="sudo apt-utils"
OVERRIDER_COMPRESSION_TYPE="gzip"
ENABLE_EXIT=true
DISABLE_LOCAL_DEBOOTSTRAP=true
ENABLE_USER_SETUP=false
PREFIX=$frn

additional_setup() {
    # install desktop
    shout "installing desktop"
    run_cmd apt update
    run_cmd apt install -y kali-desktop-xfce4

    # install kali-tools
    shout "installing kali-tools... (This may take long time)"
    run_cmd apt install -y kali-tools-information-gathering kali-tools-vulnerability kali-tools-web kali-tools-database kali-tools-passwords kali-tools-wireless kali-tools-reverse-engineering kali-tools-exploitation kali-tools-social-engineering kali-tools-sniffing-spoofing kali-tools-post-exploitation kali-tools-forensics kali-tools-reporting
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
sha256sum $frn-armhf*tar* > $SUITE-armhf/SHA256SUM
sha256sum $frn-amd64*tar* > $SUITE-amd64/SHA256SUM

shout "done"
