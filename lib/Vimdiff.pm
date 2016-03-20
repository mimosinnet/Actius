package Vimdiff;
# Compare the same file in two different computers

# Use {{{
use strict;
use warnings;
use 5.020;
# }}}

my $arguments = 2;

sub compare_files {

	die "package Vimdiff needs $arguments " unless scalar @ARGV == $arguments; 

	my ($local, $hostname) = @_;

	my $dir = $ENV{"PWD"};
	my $file = $dir . "/" . $local;
	die "File does not exist" unless -e $file;

	my $remote_file = "scp://mimosinnet\@$hostname/$file";
	my $ssh_test = "ssh $hostname -o 'BatchMode=yes' -o 'ConnectionAttempts=1' true";
	my @args;

	@args = ("su","-c",$ssh_test,"mimosinnet");
	system (@args) == 0 or say "unable to ssh because of: $?";

	say "vimdiff $file $remote_file";

	@args = ("vimdiff", $file, $remote_file);

	exec @args;

}

1;


