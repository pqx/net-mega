package Net::MEGA;

use strict;
use warnings;

use Moo;

use JSON::XS;
use Mojo::UserAgent;

use Cipher::CBC;
use Cipher::RSA;



has 'username' => ( is => 'ro', required => 1 );
has 'password' => ( is => 'ro', required => 1 );

has '_seq' => (
	is => 'rw',
	default => sub { 0 },
);

has '_sid' => (
	is => 'rw',
	isa => 'Int'
);


sub api_req {
	my $self = shift;

}
sub api_post {
	my $self = shift;

}



1;
 	