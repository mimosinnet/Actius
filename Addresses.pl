#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: Addresses.pl
#
#        USAGE: ./Addresses.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 05/05/13 14:06:44
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use 5.010;

die "Usage: \n Adresses adreça_a_buscar \n " unless scalar @ARGV == 1; 

my @args = ("grep", $ARGV[0], "/home/mimosinnet/.mutt/data/aliases" );

foreach (@args) {print "$_ ";} print "\n";

system(@args) == 0 or die "Unable to get the result of grep because of $!";

