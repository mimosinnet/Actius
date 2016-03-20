#!/bin/bash
cd /usr/src/linux
make && make modules_install
mount /boot/
cp -v /boot/gentoo /boot/gentoo_old
cp -v arch/x86_64/boot/bzImage /boot/gentoo
umount /boot/
emerge @module-rebuild
