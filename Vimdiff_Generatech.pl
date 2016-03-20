#!/usr/bin/env perl 
# Info {{{
#  DESCRIPTION: Compare the same file in two different computers
# }}}

# Use {{{
use strict;
use warnings;
no warnings 'experimental::smartmatch';
use 5.020;
use FindBin qw($RealBin);
use lib "$RealBin/lib";
use Vimdiff_Files;
use Cwd qw(getcwd);
# }}}

# Check if file is provided and file exists {{{
die "Usage: Vimdiff_Generatech 'file' " unless scalar @ARGV == 1; 
my $file = $ARGV[0];
die "File does not exist" unless -e $file;
# }}}

# Variable Definition {{{
my $dir = getcwd;
my $server_dir = "/home/mimosinnet/segur";
my $server = "generatech";
my $usuari = "mimosinnet";
my $port="1666";
my $path;
# }}}

my $local_file  = "$dir/$file";

# $remote file path depending on 'mimosinnet' or 'etc'? {{{
given ($dir) {
	when (/^\/home\/mimosinnet/)
		{
			($path) = $dir =~ /^\/home\/mimosinnet(.*)/;
			$path   = $server_dir .  "/o3o_mimosinnet" . $path;
		}
	when (/^\/etc/)
		{
			($path) = $dir =~ /^\/etc(.*)/;
			$path   = $server_dir .  "/o3o_etc" . $path;
		}
}
my $remote_file = "$path/$file";
# }}}

compare_files($local_file,$remote_file,$server,$port);
