package Types;

use Types::Primitives;
use Types::Array;
use Types::Map;
use Loader;

use strict;
use warnings;

use constant {
	PRIMITIVE => 0,
	ARRAY => 1,
	MAP => 2,
	OBJECT => 3,
};

# Entry point for encoding Perl Messages and values into XDR, delegates into the Types/ namespace
sub encode {
	my $class = shift;
	my $attr = shift;
	my $message = shift;

	my $attr_type = $attr->data_type();
	if ($attr_type == PRIMITIVE) {
		my $value = $attr->get_value($message);
		my $type = $attr->{isa};
		return Types::Primitives->encode($type, $value);
	} else {
		my $constraint = $attr->type_constraint();
		if ($attr_type == ARRAY) {
			my $array = $attr->get_value($message) // [];
			return Types::Array->encode($constraint->type_parameter()->name, $array);
		} elsif ($attr_type == MAP) {
			my $hash = $attr->get_value($message) // {};
                	if ($attr->does('Mapped') && $attr->is_map()) {
				my $key_types = $attr->key_types();
				return Types::Map->encode($key_types->[0], $key_types->[1], $hash);
			} else {
				die "Unsuppored non-mapped hashref ".$attr->name();
			}
		} elsif ($attr_type == OBJECT) {
			my $obj = $attr->get_value($message);
			return $obj->encode($message);
		} else {
			die "EncodeError: Unknown type '".$constraint->parent()->name()."'";
			#print "Unknown: ".$constraint->parent()->name()."\n";
			#return undef;
		}
	}
}

# Entry point for decoding XDR values into Perl Messages and values XDR, delegates into the Types/ namespace
# Supports both full 'Message' support where the return values are full Message objects and
# 'fast' mode where only Perl structures are used in the $result variable.
sub decode {
	my $class = shift;
	my $attr = shift;
	my $message = shift;
	my $buffer = shift;
	my $result = shift;

	my $attr_type = $attr->data_type();

	if ($attr_type == PRIMITIVE) {
		my $type = $attr->{isa};
		my ($value, $new_buffer) = Types::Primitives->decode($type, $buffer);
		$result->{$attr->name()} = $value;
		return ($value, $new_buffer);
	} else {
		my $constraint = $attr->type_constraint();
		if ($attr_type == ARRAY) {
			my ($value, $new_buffer) = Types::Array->decode($constraint->type_parameter()->name, $buffer, defined $result);
			$result->{$attr->name()} = $value;
			return ($value, $new_buffer);
		} elsif ($attr_type == MAP) {
			my $key_types = $attr->key_types();
			my ($value, $new_buffer) = Types::Map->decode($key_types->[0], $key_types->[1], $buffer, defined $result);
			$result->{$attr->name()} = $value;
			return ($value, $new_buffer);
		} elsif ($attr_type == OBJECT) {
			my $type = $attr->{isa};
			my $obj = Message->get_message_by_name($type);
			my $sub_result = {};
			my $new_buffer = $obj->decode_message_data($buffer, $sub_result);
			$result->{$attr->name()} = $sub_result;
			return ($sub_result, $new_buffer);
		} else {
			die "DecodeError: Unknown type '".$constraint->parent()->name()."'";
		}
	}
}

1;
