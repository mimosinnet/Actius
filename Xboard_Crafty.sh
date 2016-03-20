#!/bin/bash 
cd ~/.crafty
read black < /usr/local/bin/Xboard_Crafty.txt
opcions="-fcp crafty -fd /home/mimosinnet/.crafty -depth 0 -tc 00:01 -showThinking true -ponderNextMove false -size Large"

# If the computer played black last time:
if [ $black = "1" ] 
then
	# Play white now and store the value in /usr/local/bin/Xboard_Crafty.txt
	echo "0" > /usr/local/bin/Xboard_Crafty.txt
	xboard $opcions -mode MachineWhite 
else
	# Play black and store the value
	echo "1" > /usr/local/bin/Xboard_Crafty.txt
	xboard $opcions 
fi

