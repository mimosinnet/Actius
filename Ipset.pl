#!/usr/bin/env perl

# {{{ Description
# Perl version of BoneKracker scripts for dynamic list of network blocks
# (see: http://forums.gentoo.org/viewtopic-t-863121-start-0.html)
#
# It:
# - Downloads from these sites the list of networks that should be blocked
#		http://feeds.dshield.org/block.txt
#		http://www.wizcrafts.net/exploited-servers-iptables-blocklist.html
#		http://www.ipdeny.com/ipblocks/data/countries/$_.zone 
# - checks if the downloaded file is newer than what we have
# - defines the ipset
# - sets a list of ipset lists, to be able to block all the networks with one iptables command,
#   like, for example, "iptables -A INPUT -i -lo -p all -m set --match-set ipdeny src -j DROP"
# }}}

# {{{ packages used
use Net::Ping;
use warnings;
use strict;
use feature qw(say);
use FileHandle;
use LWP::UserAgent;
# }}}

# Configurable Variabla definition {{{
my $ping_host	= "192.168.1.1";
my @countries = qw(cn vn);
# }}}

# Basic Variable definition {{{
# Country codes can be obtained from: http://www.ipdeny.com/ipblocks/ 
my $urls_number = 2 + @countries;			# dshield + bogons + number of countries
my (@dates_last, @dates_now, @sys);			# We compare stored and present dates
my $f_dates_last = "/root/data/ipset_dates_last.txt";	# File where dates are stored
my $hostname 	= `hostname`;
my $username 	= $ENV{LOGNAME} || $ENV{USER} || getpwuid($<);
my $ipset 		= "/usr/sbin/ipset";
# }}}

# Check if we have connection (ping google.com) {{{
my $p = Net::Ping->new();
die "Unable to ping google.com" unless $p->ping($ping_host,"5");
$p->close();
# }}}

# Get stored dates {{{
my $fh = FileHandle->new;		
if ($fh->open("< $f_dates_last")) {		
	@dates_last = map /^(\d+)/, $fh->getlines;
	$fh->close;
} else {
	say "Can't open file $f_dates_last. Assuming this is the first time we run the script and setting dates to 0";
	@dates_last = ( 0 )  x $urls_number;
} # }}}

# Define urls to fetch and regex to match  {{{ 
my $i = 0;	
my @urls = (	# url, regex, stored date, set_type, set_name 
	[ 
		"http://feeds.dshield.org/block.txt",	# Must match:
		qr/^((?:\d{1,3}\.){3}\d{1,3})/m,		# 46.137.194.0	46.137.194.255	24		2650 
		$dates_last[$i++],			  			# ^^^^^^^^^^^^
		"hash:ip --netmask 24 --hashsize 64",	# all class C networks
		"block"
	],
	[ 
		"http://www.wizcrafts.net/exploited-servers-iptables-blocklist.html",
		qr/^(\d.*\d)/m,				# 14.102.160.0/19
		$dates_last[$i++],			# ^^^^^^^^^^^^^^^
		"hash:net",
		"exploited"
	]
);
for (@countries) {
	push @urls,
	[
		"http://www.ipdeny.com/ipblocks/data/countries/$_.zone", 
		qr/^(\d.*\d)/m,				# 1.0.1.0/24
		$dates_last[$i++],			# ^^^^^^^^^^
		"hash:net",
		$_
	];
} 
# }}}

# Create ipdeny ipset (storing all other ipsets) and flush {{{
@sys = ($ipset, qw(create -exist ipdeny list:set));
system(@sys) == 0 or die "Unable to \"@sys\" at $hostname with username $username because: $?";
@sys = ($ipset, qw(flush ipdeny));
system(@sys) == 0 or die "Unable to \"@sys\" at $hostname with username $username because: $?";
# }}}

# Create sets from the defined data, and return date if new networks found {{{ 
foreach (@urls) {				# Pass ArrayRef to sub create_ipset
	my ($date_now,$sucess) = &create_ipset(@{$_});
	push @dates_now, $date_now;
	my $i = pop(@{$_});
	if ($sucess) {
		@sys = (qw(ipset add ipdeny), $i);	# Add defined sets in ipdeny set list
		system(@sys) == 0 or die "Unable to add $i to global ipdeny set because: $?";
	}
	else {
		print "Unable to add $i to global ipdeny set because page did not respond \n\n";
	}
} # }}}

# Store @dates_now in file, adding the end of line (\n) {{{
$fh->open("> $f_dates_last") || die "Unable to save timestamp urls in $f_dates_last: $!";
	print $fh map "$_\n", @dates_now;
$fh->close;
# }}}

# Save ipset {{{
command( qw(/etc/init.d/ipset save) ); 		
# }}}

# SUB create_ipset: get date_now and create ipset if newer than date_last {{{ 
sub create_ipset {
	my ($url,$regex,$date_last,$set_type,$set_name) = @_; 
	print "$url \n";
	my $request = HTTP::Request->new(GET => $url);
	my $ua = LWP::UserAgent->new;
	my $response = $ua->request($request);
	# check if we can get an answer from the url {{{
	if ($response->is_success) {
		my $date_now = $response->last_modified;
		$date_now = time unless defined $date_now;
		if ($date_now > $date_last) {
			command ( qw(ipset create), "temp_$set_name", split ' ',$set_type );
			my $resp = $response->content;
			while ( $resp =~ /$regex/g ) {	# Set the ipset while there is a regex match
				command ( qw(ipset add -exist), "temp_$set_name", $1 );
			}
			command (qw(ipset create -exist), $set_name, split ' ',$set_type);
			command (qw(ipset swap), "temp_$set_name", $set_name);
			command (qw(ipset destroy), "temp_$set_name");
			my $cron_notice = "IPSet: $set_name updated (as of: $date_now).";
			command (qw(logger -p cron.notice), $cron_notice);
			}
		return ($date_now,1);
	}	
	else {
		print "Unable to open $url \n ";
		return ($date_last,0);
	} # }}}
}

sub command {
	my @args = @_;
	my $command;
	foreach (@args) { $command .= "$_ " } $command .= "\n";
	print $command;
	system(@args) == 0 or die "Unable to $command because: $?";
}

# }}}
