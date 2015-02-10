package Types::Map;

use strict;
use warnings;

use Types::Primitives;

# Returns the pack/unpack template for a given map
sub get_template {
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

	if (!Types::Primitives->can($key_type)) {
		die "Cannot use a non-primitive as a map key";
	} elsif (Types::Primitives->can($key_type) && Types::Primitives->can($value_type)) {
		# Simplest type of encode where both key/value are primitives, so can blindly decode
		return pack($self->get_template($key_type, $value_type, "encode"), (scalar keys (%$hash)), %$hash);
	} else {
		# Value is non-primtive so need to manually pack the length then each value
		my $template = Types::Primitives->templates->{$key_type}." a*";
		my $buffer = pack("N", (scalar keys (%$hash)));
		foreach my $key (keys %{$hash}) {
			$buffer .= pack($template, $key, $hash->{$key}->encode());
		}
		return $buffer;
	}
}

sub decode {
	my $class = shift;
	my $key_type = shift;
	my $value_type = shift;
	my $buffer = shift;
	my $fast = shift;

	if (!Types::Primitives->can($key_type)) {
		die "Cannot use a non-primitive as a map key";
	} elsif (Types::Primitives->can($key_type) && Types::Primitives->can($value_type)) {
		# Simplest type of decode where both key/value are primitives so can blindy decode
		my @array = unpack($class->get_template($key_type, $value_type, "decode"), $buffer);
		my $new_buffer = pop @array;
		my %value = @array;
        	return (\%value, $new_buffer);
	} else {
		# Value is non-primtive so need to manually decode the length, then each value
		my ($n, $new_buffer) = unpack("N a*", $buffer);
		my $hash;
		my $key;
		my $template = Types::Primitives->templates->{$key_type}." a*";
		for (my $i=0; $i<$n; $i++) {
			($key, $new_buffer) = unpack($template, $new_buffer);
			my $obj;
			if ($fast) {
				$obj = Message->get_message_by_name($value_type);
				my $sub_result = {};
				$new_buffer = $obj->decode_message_data($new_buffer, $sub_result);
				$hash->{$key} = $sub_result;
			} else {
				$obj = Loader->loadPlugin($value_type);
				$new_buffer = $obj->decode_message($new_buffer);
				$hash->{$key} = $obj;
			}
		}
		return ($hash, $new_buffer);
	}
}

1;
