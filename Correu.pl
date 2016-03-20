#!/usr/bin/env perl 
# {{{ Description
#===============================================================================
#
#         FILE: OffilineImap.pl
#
#        USAGE: ./OffilineImap.pl  
#
#  DESCRIPTION: OfflineImap + Notmuch
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 12/08/13 12:42:18
#     REVISION: ---
#===============================================================================
# }}}

# {{{ Use
use strict;
use warnings;
use 5.010;
use Net::Ping::External qw(ping);
# }}}

# Variables {{{
my $offlineimap = 0;
my ($pause, @args);
my @mutt = qw|mutt -F ~/.mutt/comptes/correu|;
my @urxvt = qw/urxvtc -j -ss -e/;
# }}}

# {{{ Check if we have connection (ping google.com) 
$offlineimap += 1 unless ping(host => "google.com");
$offlineimap += 1 if     `ps -C offlineimap` =~ /offlineimap/;
$offlineimap += 1 if     `ps -C mutt`        =~ /mutt/;
# }}}

# {{{ Execute offlineimap 
@args = qw/offlineimap/;
system(@args) == 0 or die "Error executing offlineimap because of $?";
# }}}

$pause = <>;

@args = (@urxvt, @mutt);
system(@args) == 0 or die "Error executing mutt because of $?";

$pause = <>;

# {{{ Execute offlineimap 
@args = qw/offlineimap/;
system(@args) == 0 or die "Error executing offlineimap because of $?";
# }}}
