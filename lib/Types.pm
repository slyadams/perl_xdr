package Types;

use Types::Primitives;
use Types::Array;
use Types::Map;

use strict;
use warnings;


sub encode {
	my $class = shift;
	my $attr = shift;
	my $message = shift;
	my $type = $attr->{isa};
	if (Types::Primitives->can($type)) {
		my $value = $attr->get_read_method_ref()->execute($message); 
		return Types::Primitives->encode($type, $value);
	} else {
		use Data::Dumper;
		my $constraint = $attr->type_constraint();
		if ($constraint->parent()->name() eq "ArrayRef") {
			my $array = $attr->get_read_method_ref()->execute($message) // [];
			return Types::Array->encode($constraint->type_parameter()->name, $array);
		} elsif ($constraint->name() eq "HashRef") {
			my $hash = $attr->get_read_method_ref()->execute($message) // {};
                	if ($attr->does('Mapped') && $attr->is_map()) {
				my $key_types = $attr->key_types();
				return Types::Map->encode($key_types->[0], $key_types->[1], $hash);
			} else {
				die "Unsuppored non-mapped hashref ".$a->name();
			}
		} else {
			print "Unknown: ".$constraint->parent()->name()."\n";
			return undef;
		}
		#print Dumper($attr->type_constraint()->parent());
		#print Dumper($attr->type_constraint()->name);
		#print Dumper($attr->type_constraint()->type_parameter()->name);
	}
}

sub decode {
	my $class = shift;
	my $type = shift;
	my $data = shift;
	if (Types::Primitives->can($type)) {
		return Types::Primitives->decode($type, $data);
	} else {
		return "";
	}
}

1;
