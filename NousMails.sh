#!/bin/bash - 
#===============================================================================
#
# Using bash-support.vim: http://www.vim.org/scripts/script.php?script_id=365
# 
#          FILE:  NumMails.sh
# 
#         USAGE:  ./NumMails.sh 
# 
#   DESCRIPTION:  Executar NousMaisl.pl
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Mimosinnet (JPT), mimosinnet@ningunlugar.org
#       COMPANY: NingúnLugar
#       CREATED: 04/09/14 22:55:57 CEST
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
perl /home/mimosinnet/Dades/Scripts/Actius/NousMails.pl

