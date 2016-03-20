# Compare local file remote file
package Vimdiff_Files;

# Use {{{
use strict;
use warnings;
use 5.020;
use Net::OpenSSH;
use File::Compare;
use Exporter::Lite;
# }}}

# Export {{{
our @EXPORT = qw(compare_files);
# }}}

# Variables {{{
my $arguments = 4;
my $usuari = "mimosinnet";
my @args;
# }}}

# sub compare_files {{{1
sub compare_files {

	die "package Vimdiff needs $arguments arguments" unless scalar @_ == $arguments; 

	my ($local, $remote, $hostname, $port) = @_;
	say "$local, $remote, $hostname, $port";

	# Definition of ssh connection {{{
	my $ssh = Net::OpenSSH->new(
		$hostname,
		user => $usuari,
		port => $port);
	# }}}

	# Check if we can connect to server {{{
	$ssh->error and
    die "Couldn't establish SSH connection: ". $ssh->error;
	# }}}

	# Get remote file {{{
	$ssh->scp_get($remote,'/tmp/remote') == 1
		or die "Unable to get remote file";
	# }}}
	
	# Compare files {{{
	if ( compare($local,"/tmp/remote") == 0 ) {
		unlink "/tmp/remote";
		return 0;
	} else {
		@args = ("vimdiff", $local, "/tmp/remote");
		# foreach (@args) { print "$_ ";} ; print "\n";
		system(@args) == 0 or die "error comparing files because of: $?";
		unlink "/tmp/remote";
		return 1;
	}
	# }}}
}

# 1}}}

1;


