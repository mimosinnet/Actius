#!/usr/bin/env perl 

# Modules {{{
use strict;
use warnings;
use Net::OpenSSH;
use File::Slurp;
use File::Copy;
use v5.20;
# }}}

# Veure què s'ha de fer amb les versions tipus "r1" 
# Sembla que ara podem isntal·lar versions "r1",
# S'ha de veure què fem quan estigui instal·lada
# Fer una funció per agrupar les comandes:
# my @args - system (@args)
my $version  = "4.4.26";
my $system   = "gentoo";
my $revision = "";
# my $remote   = "/mnt/chroot/FX-8350";
my $remote   = "/mnt/chroot/amdfam10";

# Atenció: sincronitzar també el /lib/firmware

# Variables {{{
my $kernel = "$version-$system" . $revision;
my $package = "sys-kernel/$system-sources-$version" . $revision;
my $packages = `qlist -ICS $system-sources`;
my $kernel_now = `uname -r`;
my $server="psicosocial";
my $port="1964";
my $usuari="mimosinnet";
my $boot = "/boot";
my $kernel_local  = "/boot/gentoo";
my $kernel_remote = $remote . "/usr/src/linux-$kernel/arch/x86/boot/bzImage";
my $config_local  = "/usr/src/linux-$kernel/.config";
my $config_remote = $remote . $config_local;
my @args;
my $modules_local  = "/lib64/modules/$kernel";
my $modules_remote = $remote . "$modules_local/";
# }}}

# Start {{{
print "Present kernel = $kernel_now";
say "New kernel     = $kernel\n";
say "Installed Packages = ";
say "$packages\n";
say "S'ha d'instal·lar $kernel i copiar .config\n" unless $packages =~ /$version$/m;
print "Apreta 'return' per continuar";
my $pausa = <>;

# }}}

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

# Mount /boot {{{
my @mounts = grep /boot/, read_file "/proc/self/mounts";
die "boot partition already mounted" unless scalar @mounts == 0;
@args  = ('mount',$boot);
system(@args) == 0 or die "system @args failed: $?";
# }}}

# Get files {{{
move ($kernel_local,$kernel_local . "_old") or print "Copy failed: $! \n";
$ssh->scp_get(
		{	
				quiet => 1,
				verbose => 1
		},  $kernel_remote,$kernel_local);

$ssh->rsync_get(
	{
	archive => 1, 
	verbose => 1,
	delete  => 1
	}, $modules_remote,$modules_local);
# }}}

# Install kernel, copy .config and Remove old kernels {{{

# sync if kernel not present
@args = qw(eix-update);
system(@args) == 0 or die "system @args failed: $?";
my $kernels = qx(eix --nocolor sys-kernel/$system-sources);
if ( $kernels !~ /\($version\)/ ) {
	say "Portage needs to be syncronized";
	@args = qw(emerge --sync);
	system(@args) == 0 or die "system @args failed: $?";
	@args = qw(eix-update);
	system(@args) == 0 or die "system @args failed: $?";
}

# emerge if kernel absent
@args = ("emerge", "--getbinpkgonly", "--update", "=$package");
system(@args) == 0 or die "system @args failed: $?";

# get .config file
$ssh->scp_get(
		{	
				quiet => 1,
				verbose => 1
		},  $config_remote,$config_local);

# module-rebuild
@args = qw(emerge --getbinpkgonly @module-rebuild);
system(@args) == 0 or die "system @args failed: $?";

# delete old kernels
@args = ("emerge", "--prune", "-av", "=$package");
system(@args) == 0 or die "system @args failed: $?";
# }}}

# umount /boot {{{
@mounts = grep /boot/, read_file "/proc/self/mounts";
die "boot partition not mounted" unless scalar @mounts == 1;
@args  = ('umount',$boot);
system(@args) == 0 or die "system @args failed: $?";
# }}}

# vim: tabstop=2
