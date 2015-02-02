package Types::Array;

use strict;
use warnings;

require Types;
require Loader;
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
	if (Types::Primitives->can($type)) {
		return pack($self->_getTemplate($type, "encode"), @{$array});
	} else {
		my $buffer = pack("N", scalar @{$array});
		foreach my $a (@{$array}) {
			$buffer .= $a->encode();
		}
		return $buffer;	
	}
}

sub decode {
	my $class = shift;
	my $type = shift;
	my $buffer = shift;
	if (Types::Primitives->can($type)) {
		my (@array) = unpack($class->_getTemplate($type, "decode"), $buffer);
		my $new_buffer = pop @array;
		return (\@array, $new_buffer);
	} else {
		my ($n, $new_buffer) = unpack("N a*", $buffer);
		my @array = ();
		for (my $i=0; $i<$n; $i++) {
			my $obj = Loader->loadPlugin($type);
			$new_buffer = $obj->decode_message($new_buffer);
			push(@array, $obj);
		}
		return (\@array, $new_buffer);

	}
}

1;
