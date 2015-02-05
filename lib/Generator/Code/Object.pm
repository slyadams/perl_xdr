package Generator::Code::Object;

use strict;
use warnings;
use Data::Dumper;

use base 'Generator::Code';

sub generate_package_name {
	my $class = shift;
	my $namespace = shift;
	my $package = shift;
	return "$namespace\_$package->{name}";
}



sub generate_package {
	my $class = shift;
	my $package_name = shift;
	my $namespace = shift;
	my $def = shift;
	my $comment = shift;

	my $comment_string = "";
	foreach my $comment (@{$comment}) {
		$comment_string .= "// $comment\n";
	}

	my $full_package_name = $class->generate_package_name($namespace, $def);

	return qq {package $namespace\:\:$full_package_name;

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
	return "has '$field->{name}' => (is => 'rw',";
}

sub _generate_field_line_end {
	my $class = shift;
	my $field = shift;
	return ");".(length($field->{comment}) > 0 ? " // $field->{comment}" : "");
}

sub _generate_array {
	my $class = shift;
	my $field = shift;
	my $line = $class->_generate_field_line_start($field);
	$line .= " isa => ArrayRef[$field->{data_type}]";
	$line .= $class->_generate_field_line_end($field);
	return $line;
}

sub _generate_map {
	my $class = shift;
	my $field = shift;
	my $line = $class->_generate_field_line_start($field);
	$line .= " isa => 'HashRef', traits => [\"Mapped\"], ";
	$line .= " key_type => [$field->{options}->{key}, $field->{data_type}]";
	$line .= $class->_generate_field_line_end($field);
	return $line;
}

sub _generate_primitive {
	my $class = shift;
	my $field = shift;
	my $line = $class->_generate_field_line_start($field);
	$line .= " isa => '$field->{data_type}', ";
	if ($field->{options}->{default}) {
		$line .= "default => $field->{options}->{default}";
	}
	$line .= $class->_generate_field_line_end($field);
	return $line;
}

sub generate {
	my $class = shift;
	my $object = shift;

	my $extends_string = "extends 'Message';\n";
	my $field_string = ""; 
	foreach my $field (@{$object->{content}}) {
		my $line = "";
		if (($field->{type} eq "option") && ($field->{name} eq "extends")) {
			$extends_string = $class->_generate_extends($field);
		} else {
			if ($field->{repeated}) {
				if ($field->{options}->{key}) {
					$line = $class->_generate_map($field);
				} else {
					$line = $class->_generate_array($field);
				}
			} else  {
				$line .= $class->_generate_primitive($field);

			}
#			$field_string .= "has '$field->{name}' => (is => 'rw', isa => '$data_type',";
#			if ($field->{type} eq "option") {
#				$field_string .= " default => '$field->{value}',";
#			}
#			chop($field_string);
#			$field_string .= ");\n";
		}
		if (length($line) > 0) {
			$field_string .= $line."\n";
		}
	}
	$field_string .= "\n".$class->generate_footer();
	return "$extends_string\n$field_string";
}

1;
