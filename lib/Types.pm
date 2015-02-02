package Types;

use Types::Primitives;
use Types::Array;
use Types::Map;
use Loader;

use strict;
use warnings;


sub encode {
	my $class = shift;
	my $attr = shift;
	my $message = shift;
	my $type = $attr->{isa};
	if (Types::Primitives->can($type)) {
		my $value = $attr->get_value($message);
		return Types::Primitives->encode($type, $value);
	} else {
		use Data::Dumper;
		my $constraint = $attr->type_constraint();
		if ($constraint->parent()->name() eq "ArrayRef") {
			my $array = $attr->get_value($message) // [];
			return Types::Array->encode($constraint->type_parameter()->name, $array);
		} elsif ($constraint->name() eq "HashRef") {
			my $hash = $attr->get_value($message) // {};
                	if ($attr->does('Mapped') && $attr->is_map()) {
				my $key_types = $attr->key_types();
				return Types::Map->encode($key_types->[0], $key_types->[1], $hash);
			} else {
				die "Unsuppored non-mapped hashref ".$a->name();
			}
		} elsif ($constraint->parent()->name() eq "Object") {
			my $obj = $attr->get_value($message);
			return $obj->encode($message);
		} else {
			print "Unknown: ".$constraint->parent()->name()."\n";
			return undef;
		}
	}
}

sub decode {
	my $class = shift;
	my $attr = shift;
	my $message = shift;
	my $buffer = shift;
	my $type = $attr->{isa};
	if (Types::Primitives->can($type)) {
		my ($value, $new_buffer) = Types::Primitives->decode($type, $buffer);
		#$attr->get_write_method_ref()->execute($message, $value);
		$attr->set_value($message, $value);
		return ($value, $new_buffer);
	} else {
		use Data::Dumper;
		my $constraint = $attr->type_constraint();
		if ($constraint->parent()->name() eq "ArrayRef") {
			my ($value, $new_buffer) = Types::Array->decode($constraint->type_parameter()->name, $buffer);
			$attr->set_value($message, $value);
			return ($value, $new_buffer);
		} elsif ($constraint->name() eq "HashRef") {
			my $key_types = $attr->key_types();
			my ($value, $new_buffer) = Types::Map->decode($key_types->[0], $key_types->[1], $buffer);
			$attr->set_value($message, $value);
			return ($value, $new_buffer);
		} elsif ($constraint->parent()->name() eq "Object") {
			my $obj = Loader->loadPlugin($type);
			my $new_buffer = $obj->decode_message($buffer);
			$attr->set_value($message, $obj);
			return ($obj, $new_buffer);
		}
	}
}

1;
