#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: GetIp.pl
#
#        USAGE: ./GetIp.pl  
#
#  DESCRIPTION: Get wan ip and send it to server
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 02/02/13 20:45:16
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use 5.010;
use LWP::Simple;

# Definition of variables {{{
my $server="generatech";
my $port="1666";
my $usuari="mimosinnet";
my $hostname= qx/'hostname'/;
chomp $hostname;
my $from_file = "/tmp/EnviarIP.txt";
my $to_file = "mimosinnet\@generatech:/home/mimosinnet/IPsOrdinadors/$hostname.txt";
my ($checkip, $ip);
# }}}

# Check if we can connect to server {{{
my @args = ("nc","-z",$server,$port);
exit unless (system(@args) == 0);
# }}}

# Get router ip {{{
$checkip = get("http://checkip.dyndns.org");
($ip) = $checkip =~ /((\d+\.){3}\d+)/;
#}}}

# Get stored IP {{{
my ($oldip, $command) = ("none") x 2 ;
if (-f $from_file) 
{
	$command = "cat $from_file";
	my ($oldip) = qx/$command/ =~ /((\d+\.){3}\d+)/;
}

exit if ($ip eq $oldip);
#}}}

# Store new IP{{{
open (my $fh, ">", $from_file) or die "cannot open $from_file $!";
	print $fh $ip;
close $fh;
#}}}

@args = ("scp",$from_file,$to_file);
system @args == 1 or die "unable to scp from $hostname to $server: $!";



