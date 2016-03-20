#!/bin/bash
dir="/mnt/Personal/"
file="Codis.txt"
# Número de dia de l'any
dia=`date +%j`

if ! grep -q 'encfs /mnt/Personal' /etc/mtab
then
	encfs --idle=30 /home/mimosinnet/Dades/Personal.enc $dir
fi
cp $dir$file $dir/Segur/$dia$file
vim "+set backupdir=$dir/Segur" $dir$file
