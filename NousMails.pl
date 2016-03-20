#!/usr/bin/perl 
#===============================================================================
#
#         FILE: NumMails.pl
#
#        USAGE: ./NumMails.pl  
#
#  DESCRIPTION: Número de mails en el correu
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), mimosinnet@ningunlugar.org
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 23/08/12 13:45:46
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use File::Find::Rule;
use Data::Dumper;
use 5.018;

my $dir = "/home/mimosinnet/Correu";
my ($numfiles, @files);
my @subdirs = File::Find::Rule->directory->in( $dir );
my @new		= sort ( grep (/new$/, @subdirs) );

say "New mail";
foreach (@new) {
	@files = File::Find::Rule->file()->in( $_);
	$numfiles = @files;
	if (@files > 0) {
		printf "%7d %s \n", $numfiles, $_;
	}
}
say "-" x 40;
