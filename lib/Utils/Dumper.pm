package Utils::Dumper;

use Moose;

# Dumps a hex structure for a given XDR buffer
sub hex {
	my $class = shift;
	my $buffer = shift;
	my $out = "";
	while ($buffer) {
		my $line = substr($buffer, 0, 16);
		if (length($buffer) > 15) {
			$buffer = substr($buffer, 16);
		} else {
			undef $buffer;
		}
		my $data = unpack("H*", $line);
		$data =~ s/(..)/$1 /g;
		$line =~ s/[^[:print:]]/ /g;
		$line =~ s/(.)/ $1 /g;
		$out .= $data."\n";
	}
	chomp($out);
	return $out;
}

# Outputs a pretty debug of a Message object
sub message {
	my $class = shift;
	my $message = shift;
	my $indent = shift // 0;
	my $include_header = shift // 1;
	my $text = $include_header ? " "x$indent.ref($message)."\n" : "";
	$indent += 3;

	foreach my $attr (@{$message->_get_ordered_attributes()}) {
		my $value = $attr->get_value($message);
		my $ref_type = ref($value);
		my $data_type = $attr->{isa};
		my $text_value = "n/a";

		if ($data_type =~ m/HashRef/) {
			$value = $value // {};
			$text_value = "{ ";
			for my $key (keys %{$value}) {
				$text_value .= " $key => $value->{$key},"; 
			}
			chop($text_value);
			$text_value .= "  }";
		} elsif ($data_type =~ m/ArrayRef/) {
			$value = $value // [];
			$text_value = "[".join(",", @{$value})."]";
		} elsif (blessed($value)) {
			$text_value = "\n".$class->message($value, $indent, 0);
			chomp($text_value);
		} else {
			$text_value = $value;
		}

		my $name_width = 40-$indent;
		$text .= sprintf("%${indent}s %-${name_width}s %-30s %-30s\n"," ",$attr->name(),$attr->{isa}, $text_value);
	}
	return $text;
}

# Returns the 'data' version of a Message (i.e. same as if the source XDR buffer had been
# decoded 'fast'
sub data {
	my $class = shift;
	my $message = shift;
	return $message->data();
}

1;
