package Generator::Code::Object;

use strict;
use warnings;

use base 'Generator::Code';

sub generate_package_name {
	my $class = shift;
	my $namespace = shift;
	my $package_name = shift;
	my $object_name = shift;
	return (defined $namespace ? $namespace."::" : "").$class->_convert_package_to_namespace($package_name)."_".$object_name;
}

sub generate_package {
	my $class = shift;
	my $package_name = shift;
	my $namespace = shift;
	my $def = shift;
	my $comment = shift;

	my $comment_string = "";
	foreach my $comment (@{$comment}) {
		$comment_string .= "# $comment\n";
	}

	my $full_package_name = $class->generate_package_name($namespace, $package_name, $def->{name});

	return qq {package $full_package_name;

$comment_string
use strict;
use warnings;

use Moose;

};
}

sub _generate_extends {
	my $class = shift;
	my $field = shift;
	return "extends '$field->{value}';";
}

sub _generate_field_line_start {
	my $class = shift;
	my $field = shift;
	return "has '$field->{name}' => (is => 'rw'";
}

sub _generate_field_line_end {
	my $class = shift;
	my $field = shift;
	return ");".(length($field->{comment}) > 0 ? " # $field->{comment}" : "");
}

sub _generate_data_type {
	my $class = shift;
	my $data_type = shift;
	my $names = shift;
	if (!defined $names->{$data_type}) {
		return $data_type;
	} elsif ($names->{$data_type} eq "enum") {
		return "uint32";
	} else {
		return $data_type;
	}
}

sub _generate_array {
	my $class = shift;
	my $field = shift;
	my $names = shift;
	my $line = $class->_generate_field_line_start($field);
	$line .= ", isa => 'ArrayRef[".$class->_generate_data_type($field->{data_type}, $names)."]'";
	$line .= $class->_generate_field_line_end($field);
	return $line;
}

sub _generate_map {
	my $class = shift;
	my $field = shift;
	my $names = shift;
	my $line = $class->_generate_field_line_start($field);
	$line .= ", isa => 'HashRef', traits => [\"Mapped\"]";
	$line .= ", key_type => [$field->{options}->{key}, \"".$class->_generate_data_type($field->{data_type}, $names)."\"]";
	$line .= $class->_generate_field_line_end($field);
	return $line;
}

sub _generate_simple {
	my $class = shift;
	my $field = shift;
	my $names = shift;
	my $line = $class->_generate_field_line_start($field);
	$line .= ", isa => '".$class->_generate_data_type($field->{data_type}, $names)."'";
	if ($field->{options}->{default}) {
		$line .= ", default => $field->{options}->{default}";
	}
	$line .= $class->_generate_field_line_end($field);
	return $line;
}

sub generate {
	my $class = shift;
	my $object = shift;
	my $names = shift;

	my $extends_string = "extends 'Message';\n";
	my $field_string = ""; 
	foreach my $field (@{$object->{content}}) {
		my $line = "";
		if (($field->{type} eq "option") && ($field->{name} eq "extends")) {
			$extends_string = $class->_generate_extends($field);
		} else {
			if ($field->{repeated}) {
				if ($field->{options}->{key}) {
					$line = $class->_generate_map($field, $names);
				} else {
					$line = $class->_generate_array($field, $names);
				}
			} else  {
				$line .= $class->_generate_simple($field, $names);

			}
		}
		if (length($line) > 0) {
			$field_string .= $line."\n";
		}
	}
	$field_string .= "\n".$class->generate_footer();
	return "$extends_string\n$field_string";
}

1;
