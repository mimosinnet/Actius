#!/usr/bin/env perl 
# Info {{{
#===============================================================================
#
#  DESCRIPTION: Parar l'Ordinador
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 04/03/15 18:35:16
#     REVISION: ---
#===============================================================================
# }}}

# Use {{{
use strict;
use warnings;
use utf8;
use v5.18;
use Tk;
# }}}

# Variables {{{
my @args;
my $hostname = `hostname`;
chomp $hostname;

# }}}

my $mw = MainWindow->new;

$mw->Label(-text => "Vols sortir de $hostname?")
	->pack(
		-side 	=> 'top',
		-expand => '1',
		-fill 	=> 'both',
		-anchor => 'center',
		-pady	=> '10',
		-padx	=> '50'
	);
$mw->Button(-text => "Si", -command => \&sub_halt)
	->pack(
		-side => 'left',
		-pady	=> '20',
		-padx	=> '30'
);
$mw->Button(-text => "Reboot", -command => \&sub_reboot)
	->pack(
		-side => 'left',
);
;
$mw->Button(-text => "No", -command => sub {exit})
	->pack(
		-side => 'right',
		-pady	=> '10',
		-padx	=> '30'
);

MainLoop;

sub sub_halt {
	&sub_tancar;
	@args = ("urxvt","-e","sh","-c","su -c halt");
	system(@args) == 0 or die "No puc sortir";
}
sub sub_reboot {
	# &sub_tancar;
	@args = ("urxvt","-e","sh","-c","su -c reboot");
	system(@args) == 0 or die "No puc sortir";
}
sub sub_tancar {
	my $offlineimap = `offlineimap`;
	die "No puc executar offlineimap" unless defined $offlineimap;
}
