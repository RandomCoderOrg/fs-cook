#!/usr/bin/env bash

target=$1

tar \
    --exclude={/data,/apex,/vendor,/system,/sdcard} \
    --exclude={/dev,/proc,/sys,/tmp/*,/mnt/*,/media/*,/lost+found/*} \
    --exclude="*.l2s.*" \
    --exclude=/${0} \
    --exclude="/${target}.tar.gz" \
    --exclude-caches-all \
    --one-file-system \
    -cpf \
     - / -P \
    | pv -s $(($(du -skx / | awk '{print $1}') * 1024)) |\
     gzip --best > /"${target}".tar.gz
