#!/bin/bash

# Fer una copia del kernel que funciona

if (ps -C X | grep -q X)
then
	mount /boot
	if (cmp -s /boot/gentoo /boot/gentoo_safe)
	then
		umount /boot
	else
		cp /boot/gentoo /boot/gentoo_safe
		umount /boot
	fi
fi
