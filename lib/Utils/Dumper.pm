package Utils::Dumper;

use Moose;

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

sub message {
	my $class = shift;
	my $message = shift;
	my $indent = shift // 0;
	my $include_header = shift // 1;
	my $text = $include_header ? " "x$indent.ref($message)."\n" : "";
	$indent += 3;
	
	foreach my $attr (@{$message->_get_ordered_attributes()}) {
		my $value = $attr->get_value($message);
		my $type = ref($value);
		my $text_value = "n/a";
		if ($type eq "") {
			$text_value = $value;
		} elsif ($type eq "ARRAY") {
			$text_value = "[".join(",", @{$value})."]";
		} elsif ($type eq "HASH") {
			$text_value = "{ ";
			for my $key (keys %{$value}) {
				$text_value .= " $key => $value->{$key},"; 
			}
			chop($text_value);
			$text_value .= "  }";
		} elsif (blessed($value)) {
			$text_value = "\n".$class->message($value, $indent, 0);
			chomp($text_value);
		}
		my $name_width = 40-$indent;
		$text .= sprintf("%${indent}s %-${name_width}s %-30s %-30s\n"," ",$attr->name(),$attr->{isa}, $text_value);
	}
	return $text;
}

1;
