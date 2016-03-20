#!/usr/bin/env perl

# Mòduls a fer servir {{{
use strict;
use warnings;
# }}}

# Definició de Xarxes {{{

# Hosts en que confiem {{{
my %hosts = (
'generatech' 	=> '158.109.174.125',
'kalimero' 	=> '158.109.174.53',
'mimoperru'	=> '158.109.147.31',
'mimosin'	=> '158.109.132.210',
'mimouab'	=> '158.109.159.170',
'o3o'		=> '158.109.144.27',
'vell' 		=> '158.109.129.52',
'mimomedia'	=> '192.168.1.100',
'o3o_casa'	=> '192.168.1.120',
'mimomini'	=> '192.168.1.122',
'video'		=> '192.168.1.127',
'mimo3oUAB'	=> '158.109.145.149',
'mimotele'	=> '192.168.1.16'
);
# }}}

# Xarxes en que confiem {{{
my %xarxes = (  
'espanya_i_mes' => '80.0.0.0/4',
'casa'          => '192.168.1.1/24',
#'jazztel'       => '37.14.0.0/16',
# 'x_caracas'   => '190.78.0.0/15',
#'jazz1'         => '188.77.0.0/16',
#'jazz2'         => '188.79.0.0/16',
#'Madrid'        => '79.159.0.0/16',
);
# }}}

# }}}

sub ipset {
	my ($conjunt,@valors) = @_;
	for (values(@valors)) {
		system("ipset add $conjunt $_ -exist");
	};
};


system("ipset create confiem hash:ip hashsize 64 maxelem 20 -exist");
system("ipset flush confiem");
my $resultat = &ipset("confiem",values(%hosts));

system("ipset create xarxes hash:net hashsize 64 maxelem 20 -exist");
system("ipset flush xarxes");
$resultat = &ipset("xarxes",values(%xarxes));

system("/etc/init.d/ipset save");
