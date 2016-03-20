#!/bin/bash 
# per muntar ntfs, escriu com a root: mount -t ntfs-3g /dev/sdb1 /mnt/usb
# en cas contrari només es pot llegir però no escriure.
# es possible que ntfs-3g passi a ser el per defecte més endavant

case $1 in
	usb | cdrom)
		dispositiu="/mnt/"$1
		opcions="";;
	*)
		echo "Escull usb, cdrom"
		exit
esac

echo "Situació Abans:"
echo "---------------"
df -hx tmpfs -x devtmpfs
echo "---------------"

if grep -q $dispositiu /etc/mtab
then
	# el desmontes
	cd ~/0Enllaços
	umount $dispositiu 
	xmessage -timeout 1 -nearmouse $dispositiu Desmuntat
else
	# en cas contrari, el montes
	mount $opcions $dispositiu
	cd $dispositiu
	xmessage -timeout 1 -nearmouse $dispositiu Muntat
fi

echo
echo
echo "Situació Després:"
echo "---------------"
df -hx tmpfs -x devtmpfs
echo "---------------"

echo
echo
echo "Arxius a $dispositiu"
echo "---------------"
ls $dispositiu
echo "---------------"
