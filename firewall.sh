#!/bin/bash
 
#Our complete stateful firewall script. This firewall can be customized for 
#a laptop, workstation, router or even a server. :)
 
#change this to the name of the interface that provides your "uplink"
#(connection to the Internet)
 
# UPLINK="eth0,wlan0"
# Revisar, sembla que no podem posar dues interficies alhora.
# UPLINK="! -i lo"
	 
#if you're a router (and thus should forward IP packets between interfaces),
#you want ROUTER="yes"; otherwise, ROUTER="no"
	 
ROUTER="no"
	 
#change this next line to the static IP of your uplink interface for static SNAT, or
#"dynamic" if you have a dynamic IP. If you don't need any NAT, set NAT to "" to
#disable it.
		 
NAT="dynamic"
		 
#change this next line so it lists all your network interfaces, including lo
		 
INTERFACES="lo eth0 wlan0"

#change this line so that it lists the assigned numbers or symbolic names (from
#/etc/services) of all the services that you'd like to provide to the general
#public. If you don't want any services enabled, set it to ""
 
# SERVICES="http ftp smtp ssh rsync"
# Torrent: 6881:6890
SERVICES="6890:6999"

# UDP ports to open
# 6881 dht_port for rtorrent
UDP_PORTS="6881"

# hosts i xarxes en que confiem
# - regla de ipset amb 'confiem'
# - regla de ipset amb 'xarxes'

if [ "$1" = "start" ]
then
	echo "********************"
	echo "* Comença Firewall *"
	echo "********************"

	# Filter
	########

	# Rebutja tot
	iptables -P INPUT DROP
	# Accepta a eth1 tot el que ve de la xarxa 10.0.*.* de la UAB, no funciona
	# iptables -A INPUT -i eth0 -p all -s 10.0.3.7 -j ACCEPT
	# Accepta el que ve de les interfaces menys la que està conectada a internet (equival a accepta lo)
	# iptables -A INPUT  ! ${UPLINK} -j ACCEPT
	# Substitueixo la regle anterior per fer referencia a lo
	iptables -A INPUT -i lo -j ACCEPT

        # Hosts en els que confiem ---------------------------------------------------------------------
	# '-i ${UPLINK}' dona problemes -> substituit per '! -i lo'
	iptables -A INPUT ! -i lo -p all -m set --match-set confiem src -j ACCEPT

        # ssh pel port 1964 en les xarxes en que confiem
	iptables -A INPUT ! -i lo -p tcp --dport 1964 -m set --match-set xarxes src -j ACCEPT

	# Connexions ja establertes
	iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

        # Eliminem adreces que no volem que entrin a la màquina
        # Ho posem després de les xarxes en que confiem, doncs les xarxes privades son bogons
	# Per saber les IPs, veure ipset list
        iptables -A INPUT -i -lo -p all -m set --match-set ipdeny src -j DROP

	#enable public access to certain services
	for x in ${SERVICES}
	do
		iptables -A INPUT -p tcp --dport ${x} -m conntrack --ctstate NEW -j ACCEPT
	done

	# Open udp_ports
	for x in ${UDP_PORTS}
	do
		iptables -A INPUT -p udp --dport ${x} -m conntrack --ctstate NEW -j ACCEPT
	done

	
	# Digues al que arriva a la interface conectada que ho rebutgem
	iptables -A INPUT -p tcp ! -i lo -j REJECT --reject-with tcp-reset
	iptables -A INPUT -p udp ! -i lo -j REJECT --reject-with icmp-port-unreachable

	#explicitly disable ECN (explicit congestion notification)
	if [ -e /proc/sys/net/ipv4/tcp_ecn ]
	then
		echo 0 > /proc/sys/net/ipv4/tcp_ecn
	fi 
					 
	#disable spoofing on all interfaces
	# IMPORTANT: REVISAR !!!
	for x in ${INTERFACES} 
	do 
		echo 1 > /proc/sys/net/ipv4/conf/${x}/rp_filter 
	done

	if [ "$ROUTER" = "yes" ]
	then
		#we're a router of some kind, enable IP forwarding
		echo 1 > /proc/sys/net/ipv4/ip_forward
			if [ "$NAT" = "dynamic" ]
			then
				#dynamic IP address, use masquerading 
				echo "Enabling masquerading (dynamic ip)..."
				iptables -t nat -A POSTROUTING ! -o lo -j MASQUERADE
			elif [ "$NAT" != "" ]
			then
				#static IP, use SNAT
				echo "Enabling SNAT (static ip)..."
				iptables -t nat -A POSTROUTING ! -o lo j SNAT --to ${UPIP}
			fi
	fi

elif [ "$1" = "stop" ]
then
	echo "**********************"
	echo "* Finalitza Firewall *"
	echo "**********************"
	iptables -F INPUT
	iptables -P INPUT ACCEPT
	#turn off NAT/masquerading, if any
	iptables -t nat -F POSTROUTING
	iptables -t mangle -F
fi

