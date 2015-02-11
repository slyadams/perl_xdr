package Generator::Code::Enum;

use strict;
use warnings;

use base 'Generator::Code';

# Generate enum package header
sub generate_package_header {
	my $self = shift;
	my $full_package_name = $self->generate_package_name();
	return qq {package $full_package_name;

use strict;
use warnings;

};
}

# Generate enum package
sub generate {
	my $self = shift;
	my $enum = $self->{object};
	my $enum_string = "";
#	if ($enum->{comment}) {
#		foreach my $comment (@{$enum->{comment}}) {
#			$enum_string .= "# $comment\n";
#		}
#	}
	$enum_string .= "use constant {\n";
	foreach my $value (@{$enum->{content}}) {
		if ($value->{type} ne "comment") {
#			my $comment = length($value->{comment}) > 0 ? "\t\t# $value->{comment}" : "";
			$enum_string .= "\t$value->{name} => $value->{value},\n";
		}
	}
	$enum_string .= "};";
	return $self->generate_package_header.$enum_string."\n\n1;";
}

1;
