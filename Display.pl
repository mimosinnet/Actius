#!/usr/bin/env perl 
# Change xorg.conf single monitor / dual monitor
use strict;
use warnings;
use 5.010;

my $usage = "Usage: \n Xorg  single|twin \n";
my $path  = "/etc/X11/";
my ($command, @sys_args); 
die $usage unless (scalar @ARGV == 1) and ($ARGV[0] =~ /single|twin/);

my @args = qw(ln -fs);

given ( $ARGV[0] ) {
	when( /single/ ) { push @args, ($path . "xorg.singlemonitor") }
	when( /twin/   ) { push @args, ($path . "xorg.twinview")      }
	default 		 { die $usage                         }
};

push @args, ($path . "xorg.conf");

foreach (@args) { $command .= " $_"; }
@sys_args = ("su", "-c", $command);
# foreach (@sys_args) { print " $_"; }
system(@sys_args) == 0 or die "unable to create the simlink because of: $?";

