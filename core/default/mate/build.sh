#!/usr/bin/env bash

export INCLUDE_PACKAGES
export NO_COMPRESSION

BUILDNAME="$(basename "$(pwd)")"
ROOT_DIR="$(git rev-parse --show-toplevel)"
BUILD_CONFIG_DIR="$ROOT_DIR/core/default"
INCLUDE_LIST="$BUILD_CONFIG_DIR/$BUILDNAME/include.list"
EXTRA_CONFIG_SCRIPT="$BUILD_CONFIG_DIR/$BUILDNAME/extra-config.sh"
OUT_DIR="${ROOT_DIR}/out/mate"
BUILD_ARCH="aarch64 armhf amd64"
PLUGIN_DIR="${ROOT_DIR}/plugins"
INCLUDE_PACKAGES="$(cat "$INCLUDE_LIST")"
#shellcheck disable=SC2034
ENABLE_EXIT=true
#shellcheck disable=SC2034
NO_COMPRESSION=true

#shellcheck disable=SC1091
source "$PLUGIN_DIR/envsetup"
#shellcheck disable=SC1091
source "$PLUGIN_DIR/colors"

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
    if [ -f "$EXTRA_CONFIG_SCRIPT" ]; then
        echo -e "${GREEN}Stage 2: Running extra config script${NC}"
        $SUDO cp "$EXTRA_CONFIG_SCRIPT" "${OUT_DIR}-${_arch}/root"
        $SUDO chmod +x "${OUT_DIR}-${_arch}/root/$EXTRA_CONFIG_SCRIPT"
        do_chroot_ae "${OUT_DIR}-${_arch}" /bin/bash -c "cd /root && /bin/bash ./extra-config.sh"
    else
        lwarn "No extra config script found"
    fi

    if $ADDITIONAL_CONF; then
        $SUDO cp "${ROOT_DIR}/core/default/mate/layout.tar.xz" "${OUT_DIR}-${_arch}/root"
        do_chroot_ae "${OUT_DIR}-${_arch}" /bin/bash -c "cd /root && tar xf layout.tar.xz"
    fi

    echo -e "${GREEN}Stage 3: Building packages${NC}"
    do_compress "${OUT_DIR}-${_arch}"
}

stage_one