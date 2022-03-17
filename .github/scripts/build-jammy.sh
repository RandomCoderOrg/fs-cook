#!/usr/bin/env bash

source plugins/envsetup

export OVERRIDER_COMPRESSION_TYPE
export ENABLE_EXIT
export ENABLE_USER_SETUP

SUITE="jammy"
frn="out/$SUITE-raw"
OVERRIDER_COMPRESSION_TYPE="gzip"
ENABLE_EXIT=true
ENABLE_USER_SETUP=false
PREFIX="${frn}"

additional_setup() {

# GitHub workflow specific
#  try to add permissions to $chroot_dir/etc/apt/sources.list
sudo chmod +r+w $chroot_dir/etc/apt/sources.list

cat <<-  EOF > $chroot_dir/etc/apt/sources.list
# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb $MIRROR $SUITE main restricted
# deb-src $MIRROR $SUITE main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb $MIRROR $SUITE-updates main restricted
# deb-src $MIRROR $SUITE-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb $MIRROR $SUITE universe
# deb-src $MIRROR $SUITE universe
deb $MIRROR $SUITE-updates universe
# deb-src $MIRROR $SUITE-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb $MIRROR $SUITE multiverse
# deb-src $MIRROR $SUITE multiverse
deb $MIRROR $SUITE-updates multiverse
# deb-src $MIRROR $SUITE-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb $MIRROR $SUITE-backports main restricted universe multiverse
# deb-src $MIRROR $SUITE-backports main restricted universe multiverse

EOF
# clean any archive if exits
apt-get clean

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
