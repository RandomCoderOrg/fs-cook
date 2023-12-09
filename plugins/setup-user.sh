#!/usr/bin/env bash 
useradd -m \
    -G sudo \
    -d /home/FS_USER \
    -k /etc/skel \
    -s /bin/bash \
    FS_USER
echo "FS_USER:FS_PASS" | chpasswd
echo FS_USER ALL=\(root\) ALL > /etc/sudoers.d/FS_USER
chmod 0440 /etc/sudoers.d/FS_USER
