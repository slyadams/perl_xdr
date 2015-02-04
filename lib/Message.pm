package Message;

use Moose;
use Types;
use Types::PrimitiveConstraints;
use Traits::Mapped;
use Loader;
use Data::Dumper;

my $messages = undef;
my $ordered_attributes = {};
my $inited = 0;

sub _init {
	my $self = shift;
	if (!$inited) {
		$inited = 1;
		$self->_get_ordered_attributes();
		$self->_load_messages();
	}
}

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

sub BUILD {
	my $self = shift;
	$self->_init();
}

sub _get_ordered_attributes {
	my $self = shift;
	my $ref = ref($self);

	if (!defined $ordered_attributes->{$ref}) {
		$ordered_attributes->{$ref} = $self->_build_ordered_attributes();
	}
	return $ordered_attributes->{$ref};
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

		# I don't like this, I have to sort by the first class where a field is created
		# because inheriting messages can change the default of a field in a higher message
		# (eg. type), and doing that in Moose 'moves' the attribute into the message where
		# the default is changed, thereby messing up where it would be encoded.
		# To fix this, I look up the highest level reader for the attribute, which 'should' be
		# the first class which defined the attribute
		my @a_associated_methods = $a->associated_methods();
		my @b_associated_methods = $b->associated_methods();
		my $a_class = $a_associated_methods[0][0]->package_name();
		my $b_class = $b_associated_methods[0][0]->package_name();

		#my $d = $classes->{$a->associated_class()->name()} - $classes->{$b->associated_class()->name()};
		my $d = $classes->{$a_class} - $classes->{$b_class};
		if ($d > 0) {
			return -1;
		} elsif ($d < 0) {
			return 1;
		} else {
			return $a->insertion_order() cmp $b->insertion_order();
		}

	};
	my @attributes = ();
	my @a = $meta->get_all_attributes();
	foreach my $attr (sort $s @a) {
		push(@attributes, $attr);
	}
	return \@attributes;
}

sub _load_messages {
	my $class = shift;
	if (!defined $messages) {
		$messages = Loader->loadPlugins("../lib/Message/");
	}
	return $messages;
}

sub encode {
	my $self = shift;
	my $buffer = "";
	foreach my $attr (@{$self->_get_ordered_attributes()}) {
		$buffer .= Types->encode($attr, $self);
	}
	return $buffer;
}

sub _get_message_meta {
	my $class = shift;
	my $buffer = shift;

	my ($version, $type) = unpack("n n", $buffer);
	return { version => $version, type => $type};
}

sub decode_message_fast {
	my $self = shift;
	my $buffer = shift;
	my $result = shift;

	# decode entire message with appropriate type
	foreach my $attr (@{$self->_get_ordered_attributes()}) {
		my $value;
		($value, $buffer) = Types->decode($attr, $self, $buffer, $result);
	}
	return $buffer;
}

sub decode_message {
	my $self = shift;
	my $buffer = shift;
	
	# decode entire message with appropriate type
	foreach my $attr (@{$self->_get_ordered_attributes()}) {
		my $value;
		($value, $buffer) = Types->decode($attr, $self, $buffer);
	}
	return $buffer;
}

sub decode {
	my $class = shift;
	my $buffer = shift;
	my $fast = shift;

	# decode first two fields to get type
	my $message_meta = $class->_get_message_meta($buffer);
	my $messages = $class->_load_messages();
	if ($fast) {
		my $result = {};
		my $message = Message->get_message_by_id($message_meta->{type});
		my $remaing_buffer = $message->decode_message_fast($buffer, $result);
		return $result;
	} else {
		my $message = Loader->loadPlugin(ref($messages->{id}->{$message_meta->{type}}));
		my $remaining_buffer = $message->decode_message($buffer);
		return $message;
	}
}

__PACKAGE__->meta->make_immutable();

1;
