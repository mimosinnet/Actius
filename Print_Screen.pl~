#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: Print_Screen.pl
#
#        USAGE: ./Print_Screen.pl  
#
#  DESCRIPTION: Print Screen
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 04/05/13 22:59:29
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use 5.010;

die "Usage: \n Print_Screen root|area|window|delay \n" unless 
	(scalar @ARGV == 1) and ($ARGV[0] =~ /root|area|window|delay/);

my $timestamp = `date +%Y_%m-%d_%H-%M`; 
chomp $timestamp;
my $target    = "/home/mimosinnet/Dades/Imatges/ScreenShots";
my (@args, $window);

given ( $ARGV[0] ) {
	when( 'root'   ) { @args = ("import", "-window", "root", "$target/$timestamp.png") 	}
	when( 'area'   ) { @args = ("import", "$target/$timestamp.png") 					}
	when( 'window' ) { 
		$window = `xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)"`;
		($window) = $window =~ /(0.*$)/ ;
		@args = ("import", "-window", $window, "$target/$timestamp.png") 
	}
	when( 'delay'  ) {
		sleep 5;
		$window = `xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)"`;
		($window) = $window =~ /(0.*$)/ ;
		@args = ("import", "-window", $window, "$target/$timestamp.png")
	}
};

system(@args) == 0 or die "unable to do the screenshot because of: $?";

@args = ("xmessage", "-nearmouse", "Captura de Pantalla Feta");
system(@args) == 0 or die "unable to show message because of: $?";

