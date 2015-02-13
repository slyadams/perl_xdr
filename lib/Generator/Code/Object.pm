package Generator::Code::Object;

use strict;
use warnings;

use base 'Generator::Code';

# Generate package header, including required enum uses
sub generate_package_header {
	my $self = shift;

#	my $comment_string = "";
#	foreach my $comment (@{$self->{object}->{comment}}) {
#		$comment_string .= "# $comment\n";
#	}

	my $full_package_name = $self->generate_package_name();

	my $header = 	"package $full_package_name;\n\n";
	$header .= 	"use strict;\n";
	$header .= 	"use warnings;\n";
#	$header .= length($comment_string) > 0 ? "\n$comment_string\n" : "";

	foreach my $package (sort keys %{$self->{use_packages}}) {
		$header .= "use $package;\n";
	}
	$header .= "use Moose;\n";
	$header .= "use Types;\n";
	return $header;
}

sub _convert_extends_to_package {
	my $self = shift;
	my $field_name = shift;
	if (index($field_name,'.') == -1) {
		return $self->_generate_package_name($self->{package_name}, $field_name);
	} else {
		return $self->_generate_package_name($self->{namespace}, $self->_convert_package_to_namespace($field_name));
	}
}

# Generate the 'extends' directive
sub _generate_extends {
	my $self = shift;
	my $field = shift;
	my $package_name = $self->_convert_extends_to_package($field->{value});
	return "extends '$package_name';";
}

# Generate generic Moose attribute pre-amble
sub _generate_field_line_start {
	my $class = shift;
	my $field = shift;
	my $inherited = shift // 0;
	if ($inherited) {
		return "has '+$field->{name}' => (";
	} else {
		return "has '$field->{name}' => (is => 'rw'";
	}
}

# Generate generic Moose attribute post-amble
sub _generate_field_line_end {
	my $class = shift;
	my $field = shift;
	return ");";
#".(length($field->{comment}) > 0 ? " # $field->{comment}" : "");
}

# Generate a data type value for an attribute line, whether its primitive, enum or object
sub _generate_data_type {
	my $self = shift;
	my $data_type = shift;
	my $lookup = shift;
	if (!defined $lookup->{$data_type}) {
		return $data_type;
	} elsif ($lookup->{$data_type}->{type} eq "enum") {
		return "uint32";
	} elsif ($lookup->{$data_type}->{type} eq "object") {
		return $self->_generate_package_name($self->{package_name}, $data_type);
	}
}

# Generate the gubbins of an arrayref attribute
sub _generate_array {
	my $self = shift;
	my $field = shift;
	my $lookup = shift;
	my $line = $self->_generate_field_line_start($field);
	$line .= ", isa => 'ArrayRef[".$self->_generate_data_type($field->{data_type}, $lookup)."]', traits => [\"DataType\"]";
	$line .= ", data_type => Types::ARRAY";
	$line .= $self->_generate_field_line_end($field);
	return $line;
}

# Generate the gubbins of a hashref attribute
sub _generate_map {
	my $self = shift;
	my $field = shift;
	my $lookup = shift;
	my $line = $self->_generate_field_line_start($field);
	$line .= ", isa => 'HashRef', traits => [\"Mapped\", \"DataType\"]";
	$line .= ", key_types => [$field->{options}->{key}, \"".$self->_generate_data_type($field->{data_type}, $lookup)."\"], data_type => Types::MAP";
	$line .= $self->_generate_field_line_end($field);
	return $line;
}

sub _is_inherited {
	my $self = shift;
	my $field_name = shift;
	my $lookup = shift;

	my $object = $self->{object};
	foreach my $field (@{$object->{content}}) {
		if (($field->{type} eq "option") && ($field->{name} eq "extends")) {
			return 1;
		}
	}
	return 0;
}

sub _generate_inherited {
	my $self = shift;
	my $field = shift;
	my $inherited_line = $self->_generate_field_line_start($field, 1);
	$inherited_line .= "default => $field->{value}";
	$inherited_line .= $self->_generate_field_line_end($field);

	my $full_line = $self->_generate_field_line_start($field);
	$full_line .= ", isa=>'header_int', default => $field->{value}, traits => [\"DataType\"], data_type => Types::PRIMITIVE";
	$full_line .= $self->_generate_field_line_end($field);

	my $lines = "eval {\n";
	$lines 	 .= "\t$inherited_line\n";
	$lines   .= "};\n";
	$lines   .= "if (\$\@) {\n";
	$lines   .= "\t$full_line\n";
	$lines   .= "}\n";
	return $lines;
}

# Generate the gubbins of a non arrayref/hashref attribute
sub _generate_simple {
	my $self = shift;
	my $field = shift;
	my $lookup = shift;
	my $enum_lookup = shift;
	my $data_type = $field->{data_type};

	my $line = $self->_generate_field_line_start($field);
	if ($field->{type} eq "option") {
		if ($field->{name} ne "type" && $field->{name} ne "version") {
			return "";
		} elsif ($self->_is_inherited($field->{value}, $lookup)) {
			return $self->_generate_inherited($field);
		}
		$line .= ", isa => 'header_int', default => $field->{value}";
	} else {
		$line .= ", isa => '".$self->_generate_data_type($data_type, $lookup)."'";
		if ($field->{options}->{default}) {
			my $default = $field->{options}->{default};
			if ($data_type eq "bool") {
				$default = ($default eq "true") ? 1 : 0;
			} elsif (exists $lookup->{$data_type} && $lookup->{$data_type}->{type} eq "enum") {
				my $enum_package = $enum_lookup->{$field->{data_type}};
				$self->{use_packages}->{$enum_package} = 1;
				$default = "$enum_package->$default";
				
			}
			$line .= ", default => $default";
		}
	}
	$line .= ", traits => [\"DataType\"]";
	if (!defined $lookup->{$data_type} || $lookup->{$data_type}->{type} eq "enum") {
		$line .= ", data_type => Types::PRIMITIVE";
	} else {
		$line .= ", data_type => Types::OBJECT";
	}
	$line .= $self->_generate_field_line_end($field);
	return $line;
}

# Generate object package contents
sub generate {
	my $self = shift;
	my $lookup = shift;
	my $enum_lookup = shift;

	my $object = $self->{object};
	my $extends_string = "extends 'Message';";
	my $field_string = ""; 
	foreach my $field (@{$object->{content}}) {
		if ($field->{type} eq "comment") {
			next;
		}
		my $line = "";
		if (($field->{type} eq "option") && ($field->{name} eq "extends")) {
			$extends_string = $self->_generate_extends($field);
		} else {
			if ($field->{repeated}) {
				if ($field->{options}->{key}) {
					$line = $self->_generate_map($field, $lookup);
				} else {
					$line = $self->_generate_array($field, $lookup);
				}
			} else  {
				$line .= $self->_generate_simple($field, $lookup, $enum_lookup);

			}
		}
		if (length($line) > 0) {
			$field_string .= $line."\n";
		}
	}
	$field_string .= "\n".$self->generate_footer();

	return $self->generate_package_header()."\n$extends_string\n\n$field_string";
}

1;
