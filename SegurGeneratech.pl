#!/usr/bin/env perl

# Info {{{
# Primer de tot mirem si hem d'executar el script:
# 	- Si rsync s'està executant no l'executem
#	- Si wlan0 no está activada no l'executem
#	- Si mimosinnet respon l'executem
#	- Si podem connectar al port 22 fem rsync

# Server: mimomedia (192.168.1.100)
# ssh host: mimosinnet 
# local mount-point: /mnt/MimoSegur
# data to back-up: /home/mimosinnet /etc/
# files not-to-backup: /home/mimosinnet/Sistema/ExclouArxius 
# }}}

# Modules {{{
use strict;
use warnings;
use DateTime;
use Data::Dumper;
use Net::OpenSSH;
use 5.018;
# }}}

# Definition of server {{{
# my $server="psicosocial";
# my $port="1964";
my $server="generatech";
my $port="1666";
my $usuari="mimosinnet";
my $key_password=`cat /home/mimosinnet/Dades/Scripts/Actius/SegurGeneratech.txt`;
chomp $key_password;
my $key_path="/home/mimosinnet/.ssh/mimomedia";
my $hostname=`hostname`;
chomp $hostname;
die "Sembla que hi ha un problema amb el hostname: $hostname" if $hostname =~ /localhost/;
# }}}

# Definition of ssh connection {{{
my $ssh = Net::OpenSSH->new(
	$server,
	user => $usuari,
	port => $port,
	passphrase => $key_password,
	key_path => $key_path);
# }}}

# Check if we can connect to server {{{
$ssh->error and
    die "Couldn't establish SSH connection: ". $ssh->error;
# }}}

# Exit if rsync is running {{{
exit if  `ps -C rsync` =~ /rsync/;
# }}}

# Definition of directories and rsync options {{{
my $avui =  DateTime->now;
my $exclude="/home/$usuari/Dades/Sistema/ExclouArxius.txt";
# }}}

# assign directory to backup to a hash of anonymous arrays: {{{
# 	- source 
# 	- destination
# 	- backup-dir

my %dir_param = (
	$usuari	=> ["/home/$usuari/"],
	"etc"	=> ["/etc/"],
	"root"	=> ["/root/"], );

my $i;
foreach $i (keys %dir_param) {
	push @{$dir_param{$i}},(
		"/home/$usuari/segur/$hostname" . "_$i",
		"/home/$usuari/segur/BKP/$hostname" . "_$i/$avui");
}

# print Dumper(%dir_param);

# }}}

# Do the syncrhonisation {{{
foreach $i (keys %dir_param) {
 	my ($source,$destination,$backup) = @{$dir_param{$i}};
	my $options = {
		verbose 	=> 1,
		archive 	=> 1,
		backup		=> 1,
		one_file_system => 1,
#		dry_run		=> 1,
		delete		=> 1,
		exclude_from	=> $exclude,
		backup_dir	=> $backup
	};

	# say "source = $source";
	# say "destination = $destination";
	# say "backup = $backup";

	$ssh->rsync_put($options,$source,$destination);
}
# }}}

# vim: tabstop=2
