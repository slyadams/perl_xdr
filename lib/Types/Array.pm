package Types::Array;

use strict;
use warnings;

require Types;

sub _getTemplate {
	my $class = shift;
	my $type = shift;
	return "N/(".Types->templates->{$type}.")*";
}

sub encode {
	my $self = shift;
	my $type = shift;
	my $array = shift;
	return pack($self->_getTemplate($type), @{$array});
}

sub decode {
	my $class = shift;
	my $type = shift;
	my $data = shift;
	my @array = unpack($class->_getTemplate($type), $data);
	return \@array;
}

1;
