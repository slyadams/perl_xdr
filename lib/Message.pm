package Message;

use Moose;
use Types;
use Types::PrimitiveConstraints;
use Traits::Mapped;
use Traits::DataType;
use Loader;
use Data::Dumper;

our $messages = undef;
our $ordered_attributes = {};
our $inited = 0;

# Start of class init() methods

sub _build_ordered_attributes {
	my $class = shift;

	my $meta = $class->meta();
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

		# I don't like this, I have to sort by the first class where a field is created
		# because inheriting messages can change the default of a field in a higher message
		# (eg. type), and doing that in Moose 'moves' the attribute into the message where
		# the default is changed, thereby messing up where it would be encoded.
		# To fix this, I look up the highest level reader for the attribute, which 'should' be
		# the first class which defined the attribute
		# I also force 'option version' and 'option type' to positions 1 and 2

		if (($a->{isa} eq "header_int") && ($b->{isa} eq "header_int")) {
			# Seeing both type and version so return based on setting version first
			return $a->{name} eq "version" ? -1 : 1;
		} elsif ($a->{isa} eq "header_int") {
			# Only seeing 1 header_int, so it comes first
			return -1;
		} elsif ($b->{isa} eq "header_int") {
			# Only seeing 1 header_int, so it comes first
			return 1;
		} else {
			my @a_associated_methods = $a->associated_methods();
			my @b_associated_methods = $b->associated_methods();
			my $a_class = $a_associated_methods[0][0]->package_name();
			my $b_class = $b_associated_methods[0][0]->package_name();
			my $d = $classes->{$a_class} - $classes->{$b_class};
			if ($d > 0) {
				return -1;
			} elsif ($d < 0) {
				return 1;
			} else {
				return $a->insertion_order() <=> $b->insertion_order();
			}
		}
	};
	my @attributes = ();
	my @a = $meta->get_all_attributes();
	foreach my $attr (sort $s @a) {
		push(@attributes, $attr);
	}
	return \@attributes;
}

sub _get_ordered_attributes {
	my $self = shift;
	my $ref = ref($self) || $self;
	if (!defined $ordered_attributes->{$ref}) {
		$ordered_attributes->{$ref} = $self->_build_ordered_attributes();
	}
	return $ordered_attributes->{$ref};
}

sub _load_messages {
	my $class = shift;
	if (!defined $messages) {
		my $loader = new Loader();
		$messages = $loader->loadPlugins();
	}
	return $messages;
}

sub init {
	my $self = shift;
	if (!$inited) {
		$inited = 1;
		$self->_get_ordered_attributes();
		$self->_load_messages();
	}
}

# End of class init() methods

sub get_message_by_name {
	my $class = shift;
	my $package_name = shift;
	return $messages->{name}->{$package_name};
}

sub get_message_by_id {
	my $class = shift;
	my $id = shift;
	return $messages->{id}->{$id};
}

# Encode functions

sub encode {
	my $self = shift;
	my $buffer = "";
	foreach my $attr (@{$self->_get_ordered_attributes()}) {
		$buffer .= Types->encode($attr, $self);
	}
	return $buffer;
}

sub from_data {
	my $class = shift;
	my $data = shift;
	my $message;

	$class->init();

	foreach my $attr (@{$class->_get_ordered_attributes()}) {
		my $attr_type = $attr->data_type();

		if ($attr_type == Types->OBJECT) {
			Class::Load::load_class($attr->{isa});
			$data->{$attr->{name}} = $attr->{isa}->from_data($data->{$attr->{name}});
		} elsif ($attr_type == Types->ARRAY) {
			my $constraint_type = $attr->type_constraint()->type_parameter()->name;
			if (!Types::Primitives->can($constraint_type)) {
				Class::Load::load_class($constraint_type);
				my @array;
				foreach my $item (@{$data->{$attr->{name}} // []}) {
					push(@array, $constraint_type->from_data($item));
				}
				$data->{$attr->{name}} = \@array;
			}
		} elsif ($attr_type == Types->MAP) {
			my $constraint_type = $attr->key_types()->[1];
			if (!Types::Primitives->can($constraint_type)) {
				Class::Load::load_class($constraint_type);
				my %hash;
				foreach my $key (keys %{$data->{$attr->{name}} // {} }) {
					$hash{$key} = $constraint_type->from_data($data->{$attr->{name}}->{$key});
				}
				$data->{$attr->{name}} = \%hash;
			}
		}
	}
	return new $class($data);
}

# Decode functions

sub _get_message_meta {
	my $class = shift;
	my $buffer = shift;

	my ($version, $type) = unpack("n n", $buffer);
	return { version => $version, type => $type};
}

sub _data_item {
	my $self = shift;
	my $item = shift;
	if (blessed $item) {
		return $item->data();
	} else {
		return $item;
	}
}

sub data {
	my $self = shift;
	my $result = {};
	foreach my $attr (@{$self->_get_ordered_attributes()}) {
		my $value = $attr->get_value($self);
		my $type = ref($value);
		my $data_value;
		if ($type eq "") {
			$data_value = $value;
		} elsif ($type eq "ARRAY") {
			$data_value = [];
			foreach my $item (@{$value}) {
				push(@{$data_value}, $self->_data_item($item));
			}
		} elsif ($type eq "HASH") {
			for my $key (keys %{$value}) {
				$data_value->{$key} = $self->_data_item($value->{$key});
			}
		} elsif (blessed($value)) {
			$data_value = $value->data();
		}
		$result->{$attr->{name}} = $data_value;
	}
	return $result;
}

sub decode {
	my $class = shift;
	my $buffer = shift;

	$class->init();
	my $result = $class->decode_data($buffer);

	# Creste and return mesage of appropriate type
	my $message_class;
	if ($class ne __PACKAGE__) {
		$message_class = Message->get_message_by_name($class);
	} else {
		$message_class = Message->get_message_by_id($result->{type});
	}
	return $message_class->from_data($result);
}

sub decode_message_data {
	my $self = shift;
	my $buffer = shift;
	my $result = shift;

	$self->init();

	# decode entire message with appropriate type
	foreach my $attr (@{$self->_get_ordered_attributes()}) {
		my $value;
		($value, $buffer) = Types->decode($attr, $self, $buffer, $result);
	}
	return $buffer;
}

sub decode_data {
	my $class = shift;
	my $buffer = shift;
	my $result = {};

	$class->init();

	my $message;
	if ($class ne __PACKAGE__) {
		# Someone is decoding not from the base class so they are
		# specifying exactly the class to use, so let's use it
		$message =  Message->get_message_by_name($class);
		if (!defined $message) {
			die "Cannot get Message for class '$class'";
		}
	} else {
		# decode first two fields to get type to decode with
		my $message_meta = $class->_get_message_meta($buffer);

		# decode using discovered message	
		$message = Message->get_message_by_id($message_meta->{type});
		if (!defined $message) {
			die "Cannot get Message for type '$message_meta->{type}'";
		}
	}
	my $remaining_buffer = $message->decode_message_data($buffer, $result);
	return $result;
}

__PACKAGE__->meta->make_immutable();

1;
