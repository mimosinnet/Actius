#!/usr/bin/env perl6

# {{{ Description
# load mutt
# }}}

# {{{ Use
use v6;
# }}}

# Variables {{{
my @comptes = <uab fic master postmaster mimog correu nl_mimosinnet nl_nagore test>;
# }}}


sub MAIN($compte where { $compte ~~ @comptes.any }  = 'correu' ) {
	my $config = "~/.mutt/comptes/$compte";

	my @command = "mutt", "-F", $config;
	run @command;
	run "offlineimap";
	say "Has llegit el correu del compte $compte"
}

multi sub USAGE() {
	say "Utilització: \n Correu [ " ~ @comptes ~ " ]";
}

# vim: tabstop=2
