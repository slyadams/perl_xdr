package Utils::Hex;

sub dump {
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

1;
