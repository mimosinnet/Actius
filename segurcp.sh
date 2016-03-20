#!/bin/bash 

# Primer de tot mirem si hem d'executar el script:
# 	- Si rsync s'està executant no l'executem
#	- Si wlan0 no está activada no l'executem
#	- Si mimosinnet respon l'executem
#	- Si podem connectar al port 22 fem rsync

# Server: mimomedia (192.168.1.100)
# ssh host: mimosinnet 
# local mount-point: /mnt/MimoSegur
# data to back-up: /home/mimosinnet /etc/
# files not-to-backup: /home/mimosinnet/Sistema/ExclouArxius 

OPTIONS="-abSx --delete"
AVUI=$(date +%Y_%m-%d_%H-%M)
EXCLUDE="--exclude-from=/home/mimosinnet/Dades/Sistema/ExclouArxius.txt"
FROM1="/home/mimosinnet/"
FROM2="/etc/"
HOST="root@mimoalf"
TO="/mnt/MimoSegur"
TO1="$HOST:$TO/o3o"
TO2="$HOST:$TO/etc_o3o"
BACK_DIR1="--backup-dir=$TO/bkp/o3o/$AVUI"
BACK_DIR2="--backup-dir=$TO/bkp/etc/$AVUI"
WIRELESS_INTERFACE="wlp2s0"
MAC_MIMOALF="00:A0:C5:89:7C:1D"


# si rsync no està funcionant
if (ps -C rsync | grep -q rsync)
then
	exit
# i wlan0 está conectada
elif (/usr/sbin/ethtool $WIRELESS_INTERFACE | grep -q "Link detected: no")
then
	exit
# i estic a casa
elif [ "$(/usr/sbin/arping2 -t $MAC_MIMOALF -c 3 -i $WIRELESS_INTERFACE mimoalf | grep '3 packets received')" ]
then
	# i el port 1964 está obert
	if (nc -z mimoalf 1964)
	then
		# i puc fer ssh a mimosinnet
		if (ssh -q -o "BatchMode=yes" $HOST "echo 2>&1") 
		then
			# sincronitzo dades
			nice rsync $OPTIONS $BACK_DIR1 $EXCLUDE $FROM1 $TO1
			nice rsync $OPTIONS $BACK_DIR2 $EXCLUDE $FROM2 $TO2
		else
			echo $0"-> No puc fer ssh a "$HOST
		fi	
	else
		echo "tancat"
		echo $0"-> Port 1964 tancat a "$HOST
	fi
fi
