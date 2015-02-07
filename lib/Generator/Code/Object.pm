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
	my $lookup = shift;
	if (!defined $lookup->{$data_type}) {
		return $data_type;
	} elsif ($lookup->{$data_type}->{type} eq "enum") {
		return "uint32";
	} else {
		return $data_type;
	}
}

sub _generate_array {
	my $class = shift;
	my $field = shift;
	my $lookup = shift;
	my $line = $class->_generate_field_line_start($field);
	$line .= ", isa => 'ArrayRef[".$class->_generate_data_type($field->{data_type}, $lookup)."]'";
	$line .= $class->_generate_field_line_end($field);
	return $line;
}

sub _generate_map {
	my $class = shift;
	my $field = shift;
	my $lookup = shift;
	my $line = $class->_generate_field_line_start($field);
	$line .= ", isa => 'HashRef', traits => [\"Mapped\"]";
	$line .= ", key_type => [$field->{options}->{key}, \"".$class->_generate_data_type($field->{data_type}, $lookup)."\"]";
	$line .= $class->_generate_field_line_end($field);
	return $line;
}

sub _generate_simple {
	my $class = shift;
	my $field = shift;
	my $lookup = shift;
	my $enum_package = shift;
	my $line = $class->_generate_field_line_start($field);
	my $data_type = $field->{data_type};
	$line .= ", isa => '".$class->_generate_data_type($data_type, $lookup)."'";
	if ($field->{options}->{default}) {
		my $default = $field->{options}->{default};
		if ($data_type eq "bool") {
			$default = ($default eq "true") ? 1 : 0;
		} elsif (exists $lookup->{$data_type} && $lookup->{$data_type}->{type} eq "enum") {
			$default = "$enum_package->$default";
		}
		$line .= ", default => $default";
	}
	$line .= $class->_generate_field_line_end($field);
	return $line;
}

sub generate {
	my $class = shift;
	my $object = shift;
	my $lookup = shift;
	my $enum_package = shift;

	my $extends_string = "extends 'Message';\n";
	my $field_string = ""; 
	foreach my $field (@{$object->{content}}) {
		my $line = "";
		if (($field->{type} eq "option") && ($field->{name} eq "extends")) {
			$extends_string = $class->_generate_extends($field);
		} else {
			if ($field->{repeated}) {
				if ($field->{options}->{key}) {
					$line = $class->_generate_map($field, $lookup);
				} else {
					$line = $class->_generate_array($field, $lookup);
				}
			} else  {
				$line .= $class->_generate_simple($field, $lookup, $enum_package);

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
