package Types::Array;

use strict;
use warnings;

require Types;
require Types::Primitives;

sub _getTemplate {
	my $class = shift;
	my $type = shift;
	my $mode = shift;

        if ($mode eq "encode") {
		return "N/(".Types::Primitives->templates->{$type}.")";
	} else {
		return "N/(".Types::Primitives->templates->{$type}.") a*";
	}
}

sub encode {
	my $self = shift;
	my $type = shift;
	my $array = shift;
	return pack($self->_getTemplate($type, "encode"), @{$array});
}

sub decode {
	my $class = shift;
	my $type = shift;
	my $buffer = shift;
	my $t = $class->_getTemplate($type, "decode");
	my (@array) = unpack($t, $buffer);
	my $new_buffer = pop @array;
	return (\@array, $new_buffer);
}

1;
