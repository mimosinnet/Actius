#!/usr/bin/env perl6
use v6;

#| Opens 'pattern.ext' files and asks for deletion
sub MAIN( $pattern is copy, Str $ext ) {

	$pattern = "" if $pattern eq "all";
	my @files = '.'.IO.dir(test => /.*$pattern.*\.$ext/);

	for @files -> $file {
		my @args = 'xdg-open', $file.basename;
		my $command = run @args;
		$command.exitcode == 0 or die "system @args failed: $!";
		my $delete = prompt("\n \n Delete file $file (s/n) ");
		last if $delete eq "";
		next if $delete ne "s";
		say "mv $file /tmp/$file";
		$file.IO.rename("/tmp/$file");
		prompt("\n Press 'return' to continue ");
	}

	@files = '.'.IO.dir(test => /.*$ext$/);
	say "-" x 60;
	for @files -> $file {say "$file ";}
	say "-" x 60;
}

