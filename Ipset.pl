#!/usr/bin/env perl

# Perl version of BoneKracker scripts for dynamic list of network blocks
# (see: http://forums.gentoo.org/viewtopic-t-863121-start-0.html)
#
# It:
# - Downloads from these sites the list of networks that should be blocked
#		http://feeds.dshield.org/block.txt
#		http://www.team-cymru.org/Services/Bogons/fullbogons-ipv4.txt
#		http://www.ipdeny.com/ipblocks/data/countries/$_.zone 
# - checks if the downloaded file is newer than what we have
# - defines the ipset
# - sets a list of ipset lists, to be able to block all the networks with one iptables command,
#   like, for example, "iptables -A INPUT -i -lo -p all -m set --match-set ipdeny src -j DROP"

# {{{ packages used
use Net::Ping;
use warnings;
use strict;
use feature qw(say);
use FileHandle;
use LWP::UserAgent;
# }}}

# Basic Variable definition {{{
# Country codes can be obtained from: http://www.ipdeny.com/ipblocks/ 
my @countries = qw(cn vn);
my $urls_number = 2 + @countries;			# dshield + bogons + number of countries
my (@dates_last, @dates_now, @sys);			# We compare stored and present dates
my $f_dates_last = "/root/data/ipset_dates_last.txt";	# File where dates are stored
# }}}

# Check if we have connection (ping google.com) {{{
my $p = Net::Ping->new("icmp");				# 
$p->ping("google.com") == 1 or die "Unable to ping google.com";
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
		"http://www.team-cymru.org/Services/Bogons/fullbogons-ipv4.txt",
		qr/^(\d.*\d)/m,				# 14.102.160.0/19
		$dates_last[$i++],			# ^^^^^^^^^^^^^^^
		"hash:net",
		"bogons"
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
@sys = qw(ipset create -exist ipdeny list:set);
system(@sys) == 0 or die "Unable to create ipdeny global set because: $?";
@sys = (qw(ipset flush ipdeny));
system(@sys) == 0 or die "Unable to flush ipdeny global set because: $?";
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
@sys = qw(/etc/init.d/ipset save); 		
system(@sys) == 0 or die "Unable to save ipsets because $?";
# }}}

# SUB create_ipset: get date_now and create ipset if newer than date_last {{{ 
sub create_ipset {
	my ($url,$regex,$date_last,$set_type,$set_name) = @_; 
	my $request = HTTP::Request->new(GET => $url);
	my $ua = LWP::UserAgent->new;
	my $response = $ua->request($request);
	# check if we can get an answer from the url {{{
	if ($response->is_success) {
		my $date_now = $response->last_modified;
		if ($date_now > $date_last) {
			my @sys = (qw(ipset create), "temp_$set_name", split ' ',$set_type);
			system(@sys) == 0 or die "Unable to create temp_$set_name of type $set_type, because: $?"; 
			my $resp = $response->content;
			while ( $resp =~ /$regex/g ) {	# Set the ipset while there is a regex match
				@sys = (qw(ipset add), "temp_$set_name", $1);
				system(@sys) == 0 or die "Unable to add $1 to temp_$set_name, because: $?";
			}
			@sys = (qw(ipset create -exist), $set_name, split ' ',$set_type);
			system(@sys) == 0 or die "Unable to create $set_name of type $set_type, because: $?";
			@sys = (qw(ipset swap), "temp_$set_name", $set_name);
			system(@sys) == 0 or die "Unable to swap temp_$set_name with $set_name, because: $?";
			@sys = (qw(ipset destroy), "temp_$set_name");
			system(@sys) == 0 or die "Unable to destroy temp_$set_name, because: $?";
			my $cron_notice = "IPSet: $set_name updated (as of: $date_now).";
			@sys = (qw(logger -p cron.notice), $cron_notice);
			system(@sys) == 0 or die "Unable to send: $cron_notice to logger, because: $?";
			}
		return ($date_now,1);
	}	
	else {
		print "Unable to open $url \n ";
		return ($date_last,0);
	} # }}}
}

# }}}
