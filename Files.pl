#!/usr/bin/env perl
# Reads files and asks for deletion

# Modules {{{
use strict;
use warnings;
use 5.020;
use Term::ReadKey;
use Cwd;
use File::Copy "move";
# }}}

# Variables {{{

# Default pattern for all the files
my $pattern = $ARGV[0];

# extension
my $ext = $ARGV[1];

unless (defined $ext) {
	$pattern = "";
	$ext = $ARGV[0];
}

# print "$pattern.$ext"; exit;

my %exe = (
	'pdf'	=> 'mupdf',
	'PDF'	=> 'mupdf',
	'txt'	=> 'less',
	'odt'	=> 'lowriter',
	'doc'	=> 'antiword',
	# Exolore using docx2txt
	'docx'	=> 'lowriter',
	# Explore using feh and delete with ctrl-del
	'JPG'	=> 'xv',
	'jpg'	=> 'xv',
	'png'	=> 'xv',
	'flv'	=> 'mpv',
	'vimbackup' => 'gvim'
);

my @extensions = keys %exe;
my $usage = "USAGE:\n Files regex [ @extensions ]";

die $usage unless @ARGV > 0;
die "The extension '$ext' has not been defined" unless grep(/$ext/, keys %exe);

# Associated package
my $program = $exe{$ext};

# }}}

# Get files {{{
my @files = glob("*$pattern*.$ext");
# Test which files have been selected
# foreach (@files) { print "$_ ";} exit;

# }}}

# Read and Delete Files {{{
foreach my $file (@files) {
	say $file;
	my @args = ($program,$file);
	system(@args) == 0 or die "system @args failed: $?";
	print "\n \n Delete file $file (s/n) ";
	my $delete = ReadLine(0);
	chomp $delete;
	last if $delete eq "";
	next if $delete ne "s";
	say "mv $file /tmp/$file";
	move ($file, "/tmp/$file");
	print "\n Press 'return' to continue ";
	my $pause = ReadLine(0);
}
# }}}

# Exit and list files {{{
@files = glob("*.$ext");
say "-" x 60;
foreach my $file (@files) {say "$file ";}
say "-" x 60;
# }}}
