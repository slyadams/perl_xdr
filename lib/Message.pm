package Message;

use Moose;
use Types;
use Types::Primitives;

sub _get_ordered_attributes {
	my $self = shift;
	if (!defined $self->{_ordered_attributes}) {
		$self->{_ordered_attributes} = $self->_build_ordered_attributes();
	}
	return $self->_build_ordered_attributes();
}

sub _build_ordered_attributes {
	my $self = shift;

	my $meta = $self->meta();
	my $classes = {};
	my $i = 0;
	foreach my $class ($meta->class_precedence_list()) {
		if ($class eq "Message") {
			last;
		} else {
			$classes->{$class} = $i++;
		}
	}

	my $s = sub {
		my $d = $classes->{$a->associated_class()->name()} - $classes->{$b->associated_class()->name()};
		if ($d > 0) {
			return -1;
		} elsif ($d < 0) {
			return 1;
		} else {
			return $a->insertion_order() cmp $b->insertion_order();
		}

	};

	my @attributes = ();
	my @a = $self->meta()->get_all_attributes();
	foreach my $attr (sort $s @a) {
		#print $attr->associated_class()->name()."::".$attr->name()."\n";
		push(@attributes, $attr);
	}
	return \@attributes;
}

sub encode {
	my $self = shift;
	my $buffer = "";
	foreach my $attr (@{$self->_get_ordered_attributes()}) {
		my $value = $attr->get_read_method_ref()->execute($self);
		#print $attr->associated_class()->name()."::".$attr->name()." (".$attr->{isa}.") = ".($value // "")."\n";
		$buffer .= Types->encode($attr->{isa}, $value);
	}
	return $buffer;
}

sub decode {
	my $class = shift;
	my $buffer = shift;

	# decode first two fields to get type

	# decode entire message with appropriate type

}


1;
