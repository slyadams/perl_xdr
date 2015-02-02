package Types::Map;

use strict;
use warnings;

require Types::Primitives;

sub _getTemplate {
	my $class = shift;
	my $key_type = shift;
	my $value_type = shift;
	my $mode = shift;

	if ($mode eq "encode") {
		return "N (".Types::Primitives->templates->{$key_type}." ".Types::Primitives->templates->{$value_type}.")*";
	} else {
		return "N/(".Types::Primitives->templates->{$key_type}." ".Types::Primitives->templates->{$value_type}.")* a*";
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
	my $buffer = shift;
	my @array = unpack($class->_getTemplate($key_type, $value_type, "decode"), $buffer);
	my $new_buffer = pop @array;
	my %value = @array;
        return (\%value, $new_buffer);
}

1;
