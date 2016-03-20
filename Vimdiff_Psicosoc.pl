#!/usr/bin/env perl 
#===============================================================================
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

die "Usage: Vimdiff_Psicosoc 'file' " unless scalar @ARGV == 1; 

my $dir = $ENV{"PWD"};
my $file = $ARGV[0];
my $remote_hostname = "psicosocial";
my $remote_username = "psicosoc";
my $server = "$remote_username\@$remote_hostname//home/psicosoc/PsicoSocDevel";
my $path;

die "File does not exist" unless -e $file;

# Server directory
my $psico_dir = quotemeta "/home/mimosinnet/Dades/Scripts/Perl/Mojolicious/PsicoSoc";

if ($dir =~ /^$psico_dir/)
{
	($path) = $dir =~ /^$psico_dir(.*)/;
	$path = $server . $path;
}

my $remote_file = "scp://$path/$file";

my $ssh_test = "ssh $remote_hostname -o 'BatchMode=yes' -o 'ConnectionAttempts=1' true";
my @args;

# Estrany: si canviem "mimosinnet" per "psicosoc" no funciona
@args = ("su","-c",$ssh_test,"mimosinnet");
system (@args) == 0 or die "unable to ssh because of: $?";


say "vimdiff $file $remote_file";

@args = ("vimdiff", $file, $remote_file);
exec @args;


