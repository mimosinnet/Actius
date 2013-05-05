#!/bin/bash - 
#===============================================================================
#
# Using bash-support.vim: http://www.vim.org/scripts/script.php?script_id=365
# 
#          FILE:  Xephyr.sh
# 
#         USAGE:  ./Xephyr.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Mimosinnet (JPT), mimosinnet@ningunlugar.org
#       COMPANY: NingúnLugar
#       CREATED: 03/05/13 12:42:03 CEST
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

Xephyr -ac -br -noreset -screen 800x600 :1 &
sleep 1
DISPLAY=:1.0 fvwm-root -r /home/mimosinnet/.fvwm/wallpapers/wallpaper.png &
DISPLAY=:1.0 awesome -c ~/.config/awesome/rc.lua.new

