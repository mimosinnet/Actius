#!/bin/bash - 
#===============================================================================
#
# Using bash-support.vim: http://www.vim.org/scripts/script.php?script_id=365
# 
#          FILE:  Halt.sh
# 
#         USAGE:  ./Halt.sh 
# 
#   DESCRIPTION:  Apagar l'Ordinador
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Mimosinnet (JPT), mimosinnet@ningunlugar.org
#       COMPANY: NingúnLugar
#       CREATED: 18/12/14 03:55:52 CET
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

offlineimap
su -c halt
