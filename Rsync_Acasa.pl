#!/usr/bin/env perl

# Info {{{
# Primer de tot mirem si hem d'executar el script:
# - Si rsync s'està executant no l'executem
# }}}

# Modules {{{
use strict;
use warnings;
use 5.020;
use DateTime;
use FindBin qw($RealBin);
use lib "$RealBin/lib";
use Connection;
no warnings 'experimental::smartmatch';
# }}}

# Command Line Arguments {{{
die "usage: \n   Rsync_Acasa (B|P) (t|f) # Baixada/Pujada test/fes-ho \n"
	unless @ARGV == 2;
# }}}

# Definition of server {{{
my $server="generatech";
my $port="1666";
my $usuari="mimosinnet";
my $hostname=`hostname`;
chomp $hostname;
# }}}

# Variables {{{
my @args;
# }}}

# Check if we can connect to server with package Connection {{{
my $connect = connection($server,$usuari,$port);
# }}}

# Exit if rsync is running {{{
die "rsync is already being executed" if  `ps -C rsync` =~ /rsync/;
# }}}

# Definition of directories and Rsync Options {{{
my $avui =  DateTime->now;

my ($source, $destination, $backup);
given ( $ARGV[0] ) {
	when ( 'P' ) {	
		$source 			= "/home/$usuari/DadesUAB/Acasa/";
		$destination	= "$usuari\@$server:/home/$usuari/segur/Acasa";
		$backup 			= "/home/$usuari/segur/BKP/Acasa/$avui";}
	when ( 'B' ) {
		$source 			= "$usuari\@$server:/home/$usuari/segur/Acasa";
		$destination = "/home/$usuari/DadesUAB";
		$backup 			= "/home/$usuari/DadesUAB/BKP/$avui";}
	default 	 { die "Has d'escollir (B)aixada o (P)ujada \n ";	}
};

my $opts = "-abxv";
given ( $ARGV[1] ) {
		when ( 't' ) { $opts .= "n" }
		when ( 'f' ) { }
		default { die "Has d'escollur (t)est o (f)es-ho \n "; }
}

my @options = ($opts,"--delete");

# }}}

# Do the syncrhonisation {{{
@args = ("nice","rsync",@options,,"--backup-dir=".$backup,$source,$destination);
foreach (@args) {print "$_ ";} ; print "\n";
system(@args) == 0 or die "system @args failed: $?";
# }}}

# vim: tabstop=2
