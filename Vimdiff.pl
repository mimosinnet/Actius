#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: Vimdiff.pl
#
#        USAGE: ./Vimdiff.pl  
#
#  DESCRIPTION: Compare the same file in two different computers
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 11/03/13 01:54:24
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use 5.010;

die "Usage: Vimdiff 'file' 'hostname'" unless scalar @ARGV == 2; 

my $dir = $ENV{"PWD"};
my $file = $dir . "/" . $ARGV[0];
die "File does not exist" unless -e $file;

my $hostname = $ARGV[1];
my $remote_file = "scp://root\@$hostname/$file";
my $ssh_test = "ssh $hostname -o 'BatchMode=yes' -o 'ConnectionAttempts=1' true";
my @args;

@args = ("su","-c",$ssh_test,"mimosinnet");
system (@args) == 0 or die "unable to ssh because of: $?";

say "vimdiff $file $remote_file";

@args = ("vimdiff", $file, $remote_file);

exec @args;



