#!/usr/bin/env perl 
# Info {{{
#  DESCRIPTION: Compare remote file local file
# }}}

# Use {{{
use strict;
use warnings;
use 5.020;
use FindBin qw($RealBin);
use lib "$RealBin/lib";
use Vimdiff_Files;
use Data::Dumper;
# }}}

# Check if file is provided and file exists {{{
die "Usage: Vimdiff_files 'server' 'port' 'remote file' 'local file' " unless scalar @ARGV == 4; 
my ($server,$port,$remote_file,$local_file) = @ARGV;
die "File does not exist" unless -e $local_file;
# }}}

# Variable Definition {{{
my $dir = $ENV{"PWD"};
my $usuari = "mimosinnet";
# my $local_file  = "$dir/$file";
# }}}

my $return = compare_files($local_file,$remote_file,$server,$port);

say "Els dos arxius son iguals" if $return == 0;
