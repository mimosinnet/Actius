#!/usr/bin/env perl 
# Info {{{
# Watch file for change and set ip
# }}}

# Use {{{
use strict;
use warnings;
use v5.20;
use Linux::Inotify2;
# }}}

# Variables {{{
my $file ="/home/mimosinnet/Dades/Scripts/Perl/access_ip/data/ip.txt";
# create a new object
my $inotify = new Linux::Inotify2
	or die "Unable to create new inotify object: $!" ;
# }}}

$inotify->watch ($file, IN_CLOSE_WRITE)
   or die "watch creation failed" ;
	
while () {
  my @events = $inotify->read;
  unless (@events > 0) {
    print "read error: $!";
    last ;
  }

	open(my $fh, '<:encoding(UTF-8)', $file)
  	or die "Could not open file '$file' $!";
 
	my $row = <$fh>;
	chomp $row;

	my @args = (qw(ipset add confiem), $row);
	# foreach (@args) {print "$_ ";}
	system(@args);
}


# vim: tabstop=2
