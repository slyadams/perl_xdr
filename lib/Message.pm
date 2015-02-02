package Message;

use Moose;
use Types;
use Types::PrimitiveConstraints;
use Traits::Mapped;
use Loader;
use Data::Dumper;

my $messages = undef;
my $inited = 0;

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
	if (!$inited) {
		$inited = 1;
		$self->_get_ordered_attributes();
		$self->_load_messages();
	}
}

sub BUILD {
	my $self = shift;
	$self->_init();
}

#sub dump {
#	my $self = shift;
#	my $indent = shift // 0;
#	my $include_header = shift // 1;
#	my $text = $include_header ? " "x$indent.ref($self)."\n" : "";
#	$indent += 3;
#	
#	foreach my $attr (@{$self->_get_ordered_attributes()}) {
#		my $value = $attr->get_value($self);
#		my $type = ref($value);
#		my $text_value = "n/a";
#		if ($type eq "") {
#			$text_value = $value;
#		} elsif ($type eq "ARRAY") {
#			$text_value = "[".join(",", @{$value})."]";
#		} elsif ($type eq "HASH") {
#			$text_value = "{";
#			for my $key (keys %{$value}) {
#				$text_value .= " $key => $value->{$key},"; 
#			}
#			chop($text_value);
#			$text_value .= "}";
#		} elsif (blessed($value)) {
#			$text_value = "\n".$value->dump($indent, 0);
#			chomp($text_value);
#		}
#		my $name_width = 40-$indent;
#		$text .= sprintf("%${indent}s %-${name_width}s %-30s %-30s\n"," ",$attr->name(),$attr->{isa}, $text_value);
#	}
#	return $text;
#}

sub encode {
	my $self = shift;
	my $buffer = "";
	foreach my $attr (@{$self->_get_ordered_attributes()}) {
		#print "Encoding $self: ".$attr->name()."\n";
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

sub decode_message {
	my $self = shift;
	my $buffer = shift;
	
	# decode entire message with appropriate type
	foreach my $attr (@{$self->_get_ordered_attributes()}) {
		my $value;
#		print "Decoding $self: ".$attr->name()."\n";
		($value, $buffer) = Types->decode($attr, $self, $buffer);
	}
	return $buffer;
}

sub decode {
	my $class = shift;
	my $buffer = shift;

	# decode first two fields to get type
	my $message_meta = $class->_get_message_meta($buffer);
	my $messages = $class->_load_messages();
	my $message = $messages->{$message_meta->{type}};

	my $remaining_buffer = $message->decode_message($buffer);
	return $message;
}


1;
