package Types::Map;

use strict;
use warnings;

require Types;

sub _getTemplate {
	my $class = shift;
	my $key_type = shift;
	my $value_type = shift;
	my $type = shift;

	if ($type eq "encode") {
		return "N (".Types->templates->{$key_type}." ".Types->templates->{$value_type}.")*";
	} else {
		return "N/(".Types->templates->{$key_type}." ".Types->templates->{$value_type}.")*";
	}
}

sub encode {
	my $self = shift;
	my $key_type = shift;
	my $value_type = shift;
	my $hash = shift;
	return pack($self->_getTemplate($key_type, $value_type, "encode"), (scalar keys (%$hash)), %$hash);
}

sub decode {
	my $class = shift;
	my $key_type = shift;
	my $value_type = shift;
	my $data = shift;
	my %hash = unpack($class->_getTemplate($key_type, $value_type, "decode"), $data);
	return \%hash;
}

1;
