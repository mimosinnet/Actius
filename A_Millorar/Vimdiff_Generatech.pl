#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: Vimdiff_Generatech.pl
#
#        USAGE: ./Vimdiff.pl  
#
#  DESCRIPTION: Compare the same file in two different computers
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (),
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 11/03/13 01:54:24
#     REVISION: ---
#===============================================================================

# Use {{{
use strict;
use warnings;
use Net::OpenSSH;
use File::Compare;
no warnings 'experimental::smartmatch';
use 5.018;
# }}}

# Check if file is provided and file exists {{{
die "Usage: Vimdiff_Generatech 'file' " unless scalar @ARGV == 1; 
my $file = $ARGV[0];
die "File does not exist" unless -e $file;
# }}}

# Variable Definition {{{
my $dir = $ENV{"PWD"};
my $server_dir = "/home/mimosinnet/segur";
my $server = "generatech";
my $u_server = "mimosinnet";
my $u_local  = "perru";
my $s_local  = "mimoperru";
my $key_password="bis311caia";
my $port="1666";
my $key_path="/home/$u_local/.ssh/$s_local";
my $path;
# }}}

# Definition of ssh connection {{{
my $ssh = Net::OpenSSH->new(
	$server,
	user => $u_server,
	port => $port,
	passphrase => $key_password,
	key_path => $key_path);
# }}}

# Check if we can connect to server {{{
$ssh->error and
    die "Couldn't establish SSH connection: ". $ssh->error;
# }}}

# $remote file path depending on 'mimosinnet' or 'etc'? {{{
given ($dir) {
	when (/^\/home\/$u_local/)
		{
			($path) = $dir =~ /^\/home\/$u_local(.*)/;
			$path   = $server_dir .  "/mimomedia_mimosinnet" . $path;
		}
	when (/^\/etc/)
		{
			($path) = $dir =~ /^\/etc(.*)/;
			$path   = $server_dir .  "/mimomedia_etc" . $path;
		}
}
my $remote_file = "/$path/$file";
# }}}

# Get remote file {{{
$ssh->scp_get($remote_file,'/tmp') == 1
	or die "Unable to get remote file";
# }}}

# Compare files {{{
die "The two files are the same" if compare($file,"/tmp/$file") == 0;

my @args = ("vimdiff", $file, "/tmp/$file");
exec @args;
# }}}

