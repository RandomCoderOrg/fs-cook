#!/usr/bin/env bash
source plugins/functions

do_chroot_ae "out/arm64" cat /debootstrap/debootstrap.log
