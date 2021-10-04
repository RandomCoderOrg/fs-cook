#!/usr/bin/env bash

tar -cvpzf \
    "$1".tar.xz \
    --exclude="$1"/dev/* \
    --exclude="$1"/run/* \
    --exclude="$1"/proc/* \
    --exclude="$1"/sys/* \
    --exclude="$1"/tmp/* \
