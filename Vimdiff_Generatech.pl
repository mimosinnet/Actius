#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: Vimdiff_Generatech.pl
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

die "Usage: Vimdiff_Generatech 'file' " unless scalar @ARGV == 1; 

my $dir = $ENV{"PWD"};
my $file = $ARGV[0];
my $server = "mimosinnet\@generatech//home/mimosinnet/segur";
my $path;

my $hostname = "mimosinnet";

die "File does not exist" unless -e $file;

if ($dir =~ /^\/home\/mimosinnet/)
{
	($path) = $dir =~ /^\/home\/mimosinnet(.*)/;
	$path = $server . "/o3o_mimosinnet" . $path;
}

my $remote_file = "scp://$path/$file";

my $ssh_test = "ssh generatech -o 'BatchMode=yes' -o 'ConnectionAttempts=1' true";
my @args;

@args = ("su","-c",$ssh_test,"mimosinnet");
system (@args) == 0 or die "unable to ssh because of: $?";

say "vimdiff $file $remote_file";

@args = ("vimdiff", $file, $remote_file);
exec @args;


