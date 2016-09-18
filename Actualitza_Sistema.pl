#!/usr/bin/env perl 
# Info {{{
# Actualitza sistema
# }}}

# Use {{{
use strict;
use warnings;
use 5.020;
use FindBin qw($Bin);
use lib "$Bin/lib";
use Vimdiff_Files;
# }}}

# Variables {{{
# my $hostname = "mimosin";
my $hostname = "psicosocial";
# my $dir		 = "/mnt/toshiba_intel_core_i5";
my $dir		 = "/mnt/chroot/amdfam10";
# my $dir		 = "/mnt/chroot/FX-8530";
my $port 	 = 1964;
# }}}

# Check configs {{{
my @configs = qw/make.conf package.use package.mask package.accept_keywords/;
foreach ( @configs ) {
	my $local  = "/etc/portage/$_";
	my $remote = "$dir/$local";
	compare_files($local,$remote,$hostname,$port);
}
# }

# Actualitza {{{
my @args = qw/emerge -GDNtu @world/;
foreach (@args) {print "$_ ";}
system(@args) == 0 or die "unable to upgrade system because of $?";


@args = qw/perl-cleaner --all -- -G/;
foreach (@args) {print "$_ ";}
system(@args) == 0 or die "unable to upgrade system because of $?";

# }
