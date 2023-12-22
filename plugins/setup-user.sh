#!/usr/bin/env bash 

# username = FS_USER
# password = FS_PASS

useradd -m \
    -p "$(openssl passwd -1 FS_PASS)" \
    -G sudo \
    -d /home/FS_USER \
    -k /etc/skel \
    -s /bin/bash \
    FS_USER
echo FS_USER ALL=\(root\) ALL > /etc/sudoers.d/FS_USER
chmod 0440 /etc/sudoers.d/FS_USER
