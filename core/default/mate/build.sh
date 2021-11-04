#!/usr/bin/env bash

# Recomended only with ubuntu distros ( best: hirsute )

export INCLUDE_PACKAGES
export NO_COMPRESSION
export SUITE

export packages_buffer

BUILDNAME="mate"
ROOT_DIR="$(git rev-parse --show-toplevel)"
BUILD_CONFIG_DIR="$ROOT_DIR/core/default"
INCLUDE_LIST="$BUILD_CONFIG_DIR/$BUILDNAME/include.list"
EXTRA_INCLUDE_LIST="$BUILD_CONFIG_DIR/$BUILDNAME/include-i.list"
EXTRA_CONFIG_SCRIPT="$BUILD_CONFIG_DIR/$BUILDNAME/extra-config.sh"
OUT_DIR="${ROOT_DIR}/out/${BUILDNAME}"
BUILD_ARCH="aarch64 armhf amd64"
PLUGIN_DIR="${ROOT_DIR}/plugins"
INCLUDE_PACKAGES="$(cat "$INCLUDE_LIST")"
SUITE="hirsute" # (recomended: hirsute)
ADDITIONAL_CONF=false
#shellcheck disable=SC2034
ENABLE_EXIT=true
#shellcheck disable=SC2034
NO_COMPRESSION=true

#shellcheck disable=SC1091
source "$PLUGIN_DIR/envsetup"
#shellcheck disable=SC1091
source "$PLUGIN_DIR/colors"

function run_cmd() {
    local cmd="$*"
    do_chroot_ae "${OUT_DIR}-${_arch}" /bin/bash -c "$cmd"
}

function itterate_var() {
    local var="$1"
    export count="0"

    for element in $var; do
        ((count++))
    done
}

function stage_one() {
    export BUILD_DIR

    echo -e "${GREEN}Stage 1: Building $BUILDNAME${NC}"
    cd "$ROOT_DIR" || exit 1

    for _arch in ${BUILD_ARCH}; do
        export _arch
        msg "+ building ${_arch}"
        do_debootstrap "${OUT_DIR}-${_arch}" "$_arch" || exit 1
        second_stage
    done
}

function second_stage()
{
    # => resolv sources.list
    echo -e "deb http://ports.ubuntu.com/ubuntu-ports ${SUITE} main restricted\n\
deb-src http://archive.ubuntu.com/ubuntu/ ${SUITE} universe\n\
deb http://ports.ubuntu.com/ubuntu-ports ${SUITE} universe\n" >> "${OUT_DIR}-${_arch}"/etc/apt/sources.list

    # => update pacakges
    run_cmd "apt-get update"
    run_cmd "apt-get install bzip2 -y"


    if [ -f "$EXTRA_CONFIG_SCRIPT" ]; then
        echo -e "${GREEN}Stage 2: Running extra config script${NC}"
        $SUDO cp "$EXTRA_CONFIG_SCRIPT" "${OUT_DIR}-${_arch}/root"
        $SUDO cp "$EXTRA_INCLUDE_LIST" "${OUT_DIR}-${_arch}/root"
        run_cmd "chmod +x /root/extra-config.sh"
        run_cmd "/root/extra-config.sh"
        run_cmd "rm -rf /root/extra-config.sh"
        run_cmd "rm -rf /root/include-i.list"
    else
        lwarn "No extra config script found"
    fi

    if $ADDITIONAL_CONF; then
        cat "${ROOT_DIR}/core/default/mate/layout.tar.gz"* > "${ROOT_DIR}/core/default/mate/layout.tar.gz"
        $SUDO cp "${ROOT_DIR}/core/default/mate/layout.tar.gz" "${OUT_DIR}-${_arch}/root"
        run_cmd "tar -x --strip-components=1 -f layout.tar.xz /root"
        run_cmd "rm -rf /root/layout.tar.xz"
    fi

    # * some more cleanup
    run_cmd "apt clean"

    echo -e "${GREEN}Stage 3: Building packages${NC}"
    do_compress "${OUT_DIR}-${_arch}"
    packages_buffer+="\n${OUT_DIR}-${_arch}"
}

stage_one

# Final Echo
itterate_var "$packages_buffer"
echo -e "${GREEN}Packages built: ${count}${NC}"
echo -e "${packages_buffer}"

exit 0
