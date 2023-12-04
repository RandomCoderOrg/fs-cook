#!/usr/bin/env bash

target=$1

tar \
    --exclude={/dev,/apex,/vendor,/system,/sdcard} \
    --exclude={/proc/*,/sys/*,/tmp/*,/mnt/*,/media/*,/lost+found/*} \
    --exclude="*.l2s.*" \
    --exclude=/${0} \
    --exclude="/${target}.tar.gz" \
    --exclude-caches-all \
    --one-file-system \
    -cpf \
     - / -P \
    | pv -s $(($(du -skx / | awk '{print $1}') * 1024)) |\
     bzip2 --best > "${target}".tar.xz
