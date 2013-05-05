#!/usr/bin/env perl

# Modules {{{
use strict;
use warnings;
use Term::ReadKey;
# }}}

die "You must give an argument with the extension you want to view." unless defined $ARGV[0];

my $ext = $ARGV[0];
my %exe = (
	'pdf'	=> 'mupdf',
	'PDF'	=> 'mupdf',
	'txt'	=> 'less',
	'odt'	=> 'lowriter',
	'JPG'	=> 'xv',
	'jpg'	=> 'xv',
	'png'	=> 'xv'
);

die "The extension '$ext' has not been defined" unless grep(/$ext/, keys %exe);
my $program = $exe{$ext};

my $files = `ls *.$ext`;
my @files = split '\n', $files;
my (@args, $delete, $pause);

foreach (@files) {
	@args = ($program,$_);
	# foreach (@args) {print "$_ ";} print "\n";
	system(@args) == 0 or die "system @args failed: $?";
	print "\n \n Delete file $_ (s/n) ";
	$delete = ReadLine(0);
	chomp $delete;
	exit if $delete eq "";
	next if $delete ne "s";
	@args = ('rm',$_);
	# foreach (@args) {print "$_ ";} print "\n";
	system(@args) == 0 or die "system @args failed: $?";
	print "$_ esborrat \n \n"; 
	print "Apreta 'return' per continuar ";
	$pause = ReadLine(0);
}

