package Net::MEGA;

use strict;
use warnings;
use File::Spec::Functions;
use Moo;
use Smart::Comments;
use File::Temp;
use File::Basename;
use IPC::System::Simple qw(capturex);

our @allowed = qw(ls get put mkdir); #qw(df dl get ls mkdir mv put reg rm sync); 



has 'path_prefix' => ( is => 'rw', required => 0, default => sub { '/Root/' });

sub _path {
	my $self = shift;
	my $file = shift;
	return $self->path_prefix . $file;
}


sub cmd {
	my $self = shift;
	my $c = shift;
	my @args = @_;

	die "cmd: $c not supported" unless grep {$_ eq $c} @allowed;

	my @cmd = ("/usr/bin/env", "mega$c", @args);
	### cmd: @cmd
	my @result = capturex([0], @cmd);
	### result: @result
	return @result;
}


sub get {
	my $self = shift;
	my $source = shift;
	my $dest   = shift;
	die unless $dest;

	return $self->cmd('get', '--no-progress', $self->_path($source), '--path', $dest);
}

sub ls {
	my $self = shift;
	my $target = shift;
	my @listing = $self->cmd('ls', '-l', $self->_path($target));

	my @ret = ();
	foreach (@listing) {
		my ($node, $id, $subs, $size, $date, $time, $file) = split(/\s+/, $_, 8);
		push @ret, {
			path => $file,
			filename => basename($file),
			is_dir => $size eq '-' ? 1 : 0,
			size => $size ne '-' ? int($size) : undef,
			time => "$date $time",
		};
	}
	return @ret;
}

sub put {
	my $self   = shift;
	my $source = shift;
	my $dest   = shift;


	die "cant find source for put: $source" unless -f $source;
	die "cant put directories $source" if -d $source;
	die "no dest provided" unless $dest;

	return $self->cmd('put', $source, "--path", $self->_path($dest));
}


sub mkdir {
	my $self = shift;
	my $dir = $self->_path(shift);
	return $self->cmd('mkdir', $dir);
}


1;