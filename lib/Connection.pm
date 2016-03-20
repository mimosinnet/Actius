# Compare local file remote file
package Connection;

# Use {{{
use strict;
use warnings;
use 5.020;
use Net::OpenSSH;
use Exporter::Lite;
# }}}

# Export {{{
our @EXPORT = qw(connection);
# }}}

# Variables {{{
my $arguments = 3;
# }}}

# sub ssh connection to server {{{
sub connection {

	die "package Connection needs $arguments arguments" unless scalar @_ == $arguments; 

	my ($server, $usuari, $port) = @_;

	# Definition of ssh connection {{{
	my $ssh = Net::OpenSSH->new(
		$server,
		user => $usuari,
		port => $port);
	# }}}

	# Check if we can connect to server {{{
	$ssh->error and
    die "Couldn't establish SSH connection: ". $ssh->error;
	# }}}
	
}

# }}}

1;


