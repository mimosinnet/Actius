#!/usr/bin/env perl

# Modules {{{ 
use Text::ParseWords;
use strict;
use warnings;
# }}}

# Variables {{{
my @warning;
my $warning_level = 80;
my $fulldevice;
my $hostname = `hostname`;
my $message = "To: mimosinnet\@gmail.com
From: mimosinnet\@mimosinnet
Subject: Perill: disk ple

Missatge de la màquina $hostname:

";
# }}}

my $df = `df`;
my @df = split '\n',$df;
@df = grep { /^\// } @df;

my @words = nested_quotewords(' +', 1, @df);

my ($size, $b, @a);
foreach (@words) {
	($size) = $_->[4] =~ /(\d+)/;
	if ($size > $warning_level) {
		push @warning, $_->[0];
	}
}

foreach (@warning) {
	$fulldevice .= "El disk $_ ha superat el $warning_level% de capacitat.\n";
}

if (@warning) {
	$message .= $fulldevice;
	print $message;
}

# vim: tabstop=4
