#===============================================================================
#
#         FILE: TestConnection.pm
#
#  DESCRIPTION: Test Generatech Connection
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 16/12/14 00:41:29
#     REVISION: ---
#===============================================================================

package Generatech::TestConnection;

# Modules {{{
use strict;
use warnings;
use Net::OpenSSH;
use 5.018;
 
# }}}
# Definition of server {{{
# my $server="psicosocial";
# my $port="1964";
my $server="generatech";
my $port="1666";
my $usuari="mimosinnet";
my $hostname=`hostname`;
chomp $hostname;
my $key_password="bis311caia";
my $key_path="/home/mimosinnet/.ssh/$hostname";
# }}}

# Definition of ssh connection {{{
my $ssh = Net::OpenSSH->new(
	$server,
	user => $usuari,
	port => $port,
	passphrase => $key_password,
	key_path => $key_path);
# }}}

# Check if we can connect to server {{{
$ssh->error and
    die "Couldn't establish SSH connection: ". $ssh->error;
# }}}

1; 

# vim: tabstop=2
