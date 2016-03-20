#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: FindPdf.pl
#
#        USAGE: ./FindPdf.pl  
#
#  DESCRIPTION: Grep inside pdf files
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 01/07/13 17:53:59
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use 5.012;
use PDF::OCR2;

my $help = "Usage:\n FindPdf 'text_to_find'";

die $help unless @ARGV == 1;

opendir(my $dh, ".") || die "can't opendir this directory: $!";
while (readdir $dh) {
	if ($_ =~ /pdf$/ ) {
		my $filename = quotemeta($_);
		my $text =  `pdftotext $filename -`;
		if ($text =~ /$ARGV[0]/) {
			say $_;
		}
	}
}
