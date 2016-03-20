#!/usr/bin/env perl
# info {{{
#===============================================================================
#
#         FILE: Entra.pl
#
#        USAGE: ./Entra.pl  
#
#  DESCRIPTION: Entrar als servidors
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 02/03/15 11:31:42
#     REVISION: ---
#===============================================================================
# }}}

# Use {{{
use strict;
use warnings;
use utf8;
use v5.18;
# }}}

# Variables {{{
my $keys = `ssh-add -L`;
my $hostname = `hostname`;
my $home = $ENV{"HOME"};
my $instruction = "Escriu 'Entra servidor'";
my @servers = qw(generatech kalimero mimoalf mimocasa mimomedia mimoperru mimosin mimosinnet psicosocial); 
my @args;
# }}}

# Check for arguments {{{
die $instruction unless scalar @ARGV == 1;
my ($server) = @ARGV;
unless ( grep /$server/, @servers ) {
	print "Escull entre els següents servidors: ";
	foreach (@servers) {print "$_ ";}
	die "\n";
}
# }}}

# add ssh key {{{
@args=("ssh-add $home/.ssh/$hostname");
unless ( $keys =~ /$hostname/ ) {
	say "keys = $keys";
	say "hostname = $hostname";
	system(@args) == 0 or die "unable to add ssh-key";
}
# }}}

# ssh + tmux {{{
@args=("ssh",$server,"-t","tmux","-u","attach");
system(@args) == 0 or die "unable to ssh psicosocial";
# }}}
