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

# {{{ Check if we have connection (ping google.com) 
die "Unable to ping google.com"  unless ping(host => "google.com");
die "offlineimap being executed" if     `ps -C offlineimap` =~ /offlineimap/;
die "mutt being executed" 		 if     `ps -C mutt`        =~ /mutt/;
# }}}

# {{{ Execute offlineimap 
my @args = qw/offlineimap/;
# system(@args) == 0 or die "Error executing offlineimap because of $?";
exec @args or die "Error executing offlineimap because of $?";
# }}}
