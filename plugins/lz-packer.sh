#!/usr/bin/env bash

target=$1
target_source=/
# target_source=

tar \
    --exclude="${target_source}"dev/* \
    --exclude="${target_source}"run/* \
    --exclude="${target_source}"proc/* \
    --exclude="${target_source}"sys/* \
    --exclude="${target_source}"tmp/* \
    --exclude="${target_source}"${0} \
    --exclude="${target}" \
    --exclude-caches-all \
    -cpf \
     - "${target_source}" -P \
    | pv -s $(($(du -sk "${target_source}" | awk '{print $1}') * 1024)) |\
     lz4 -9 > "${target}".tar.gz # use high compression
