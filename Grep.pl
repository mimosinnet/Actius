#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: Grep.pl
#
#        USAGE: ./Grep.pl  
#
#  DESCRIPTION: Find string in all files
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 24/03/13 11:45:50
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use 5.010;

die "Usage: Grep string" unless scalar @ARGV == 1;

my @args = ("zsh","-c","grep \'$ARGV[0]\' *(.)" );
my $command = " ";
foreach (@args) { $command = $command. "$_ ";}
print $command . "\n" . "-" x 50 . "\n";
exec @args;
#	or die "Unable to exec $args because of: $!";
