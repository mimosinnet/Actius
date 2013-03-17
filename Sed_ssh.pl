#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: Sed_ssh.pl
#
#        USAGE: ./Sed_ssh.pl  
#
#  DESCRIPTION: Borrar línea de known_hosts
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 11/03/13 19:25:54
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use 5.010;
use Tie::File;

die "usage: 'Sed_ssh line_number'   " unless scalar @ARGV == 1;
die "line_number must have a numeric value below 100" unless $ARGV[0] > 0 and $ARGV[0] < 100;


my $file = $ENV{"HOME"} . "/.ssh/known_hosts";
tie my @file, 'Tie::File', $file or die "unable to tie file";

splice (@file,$ARGV[0]-1,1);

untie @file;

