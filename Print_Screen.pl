#!/usr/bin/env perl 
# Info {{{
#  DESCRIPTION: Print Screen
# }}}

# use {{{
use strict;
use warnings;
use experimental 'smartmatch';
use v5.20;
# }}}

# Variables {{{
my @print_option = qw/root area window delay sequence/;
my $timestamp = `date +%Y_%m-%d_%H-%M`; 
chomp $timestamp;
my $target = "/home/mimosinnet/Dades/Imatges/ScreenShots/$timestamp.png";
my (@args, $window);

die "Usage: \n Print_Screen root|area|window|delay \n" unless 
	(scalar @ARGV == 1) and ($ARGV[0] ~~ @print_option);

# }}}

# Select options {{{
for ( $ARGV[0] ) {
	if ( /root/   ) 
		{	@args = ("import", "-window", "root", $target) }
	if ( /area/   ) 
		{	@args = ("import", $target) }
	if ( /window/ )
		{ 	$window = `xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)"`;
			($window) = $window =~ /(0.*$)/ ;
			@args = ("import", "-window", $window, $target) } 
	if ( /delay/  )
		{	sleep 5;
			$window = `xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)"`;
			($window) = $window =~ /(0.*$)/ ;
			@args = ("import", "-window", $window, $target) } 
};
# }}}

# Debugging
# foreach (@args) { print "$_ "; } exit;

system(@args) == 0 or die "unable to do the screenshot because of: $?";

@args = ("xmessage", "-nearmouse", "Captura de Pantalla Feta");
system(@args) == 0 or die "unable to show message because of: $?";

