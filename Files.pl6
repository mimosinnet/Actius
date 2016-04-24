#!/usr/bin/env perl6
# Reads files in the form of pattern.extension and asks for deletion

# Modules {{{
use v6;
use IO::Glob;
# }}}

# Variables {{{

# Program associated to extension
my %exe = 
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
;

# extensions 
my @extensions = %exe.keys;

# }}}

# sub main {{{
sub MAIN($pattern is rw, $ext) {
	$pattern = "*" if $pattern eq "all";
	die "The extension '$ext' has not been defined" unless $ext ~~ @extensions.any; 
	my $program = %exe{$ext};
	my @files = glob("*$pattern*.$ext").dir;

	# Read and Delete Files {{{
	for @files -> $file {
		my @args = $program, $file.basename;
		my $command = run @args;
		$command.exitcode == 0 or die "system @args failed: $!";
		my $delete = prompt("\n \n Delete file $file (s/n) ");
		last if $delete eq "";
		next if $delete ne "s";
		say "mv $file /tmp/$file";
		my $io = IO::Path.new($file);
		$io.rename("/tmp/$file");
		prompt("\n Press 'return' to continue ");
	}
	# }}}

	# Exit and list files {{{
	@files = glob("*.$ext");
	say "-" x 60;
	for @files -> $file {say "$file ";}
	say "-" x 60;
	# }}}
}
# }}}

# sub usage {{{
sub USAGE () {
	say "USAGE:\n Files regex/all [ @extensions ]";
}
# }}}


