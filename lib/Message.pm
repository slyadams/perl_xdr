package Message;

use Moose;
use Types;
use Types::PrimitiveConstraints;
use Traits::Mapped;
use Loader;
use Data::Dumper;

my $messages = undef;

sub _get_ordered_attributes {
	my $self = shift;
	if (!defined $self->{_ordered_attributes}) {
		$self->{_ordered_attributes} = $self->_build_ordered_attributes();
	}
	return $self->{_ordered_attributes};
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
		#print $attr->associated_class()->name()."::".$attr->name()."\n";
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

sub _init {
	my $self = shift;
	$self->_get_ordered_attributes();
}

sub BUILD {
	my $self = shift;
#	$self->_init();
}

sub dump {
	my $self = shift;
	my $text = ref($self)."\n";
	foreach my $attr (@{$self->_get_ordered_attributes()}) {
		my $value = $attr->get_value($self);
		my $type = ref($value);
		$text .= "\t".$attr->name()."\t".$attr->{isa}."\t";
		if ($type eq "") {
			$text .= $value;
		} elsif ($type eq "ARRAY") {
			$text .= "[".join(",", @{$value})."]";
		} else {
			$text .= "n/a";
		}
		$text .= "\n";
	}
	return $text;
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

sub decode {
	my $class = shift;
	my $buffer = shift;

	# decode first two fields to get type
	my $message_meta = $class->_get_message_meta($buffer);
	my $messages = $class->_load_messages();
	my $message = $messages->{$message_meta->{type}};

	# decode entire message with appropriate type
	foreach my $attr (@{$message->_get_ordered_attributes()}) {
		my $value;
		($value, $buffer) = Types->decode($attr,$message,  $buffer);
	}
	return $message;
}


1;
