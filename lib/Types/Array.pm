package Types::Array;

use strict;
use warnings;

use Types;
use Loader;
use Types::Primitives;

sub get_template {
	my $class = shift;
	my $type = shift;
	my $mode = shift;

        if ($mode eq "encode") {
		return "N/(".Types::Primitives->templates->{$type}.")";
	} elsif ($mode eq "decode_fast") {
		return "N/(".Types::Primitives->templates->{$type}.")";
	} else {
		return "N/(".Types::Primitives->templates->{$type}.") a*";
	}
}

sub encode {
	my $class = shift;
	my $type = shift;
	my $array = shift;
	if (Types::Primitives->can($type)) {
		return pack($class->get_template($type, "encode"), @{$array});
	} else {
		my $buffer = pack("N", scalar @{$array});
		foreach my $a (@{$array}) {
			$buffer .= $a->encode();
		}
		return $buffer;	
	}
}

sub decode {
	my $class = shift;
	my $type = shift;
	my $buffer = shift;
	my $fast = shift;

	if (Types::Primitives->can($type)) {
		my (@array) = unpack($class->get_template($type, "decode"), $buffer);
		my $new_buffer = pop @array;
		return (\@array, $new_buffer);
	} else {
		my ($n, $new_buffer) = unpack("N a*", $buffer);
		my @array = ();
		for (my $i=0; $i<$n; $i++) {
			if ($fast) {
				my $obj = Message->get_message_by_name($type);
				my $sub_result = {};
				$new_buffer = $obj->decode_message_data($new_buffer, $sub_result);
				push(@array, $sub_result);
			} else {
				my $obj = Loader->loadPlugin($type);
				$new_buffer = $obj->decode_message($new_buffer);
				push(@array, $obj);
			} 
		}
		return (\@array, $new_buffer);
	}
}

1;
