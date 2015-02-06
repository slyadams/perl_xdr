package Generator::Code::Enum;

use strict;
use warnings;

use base 'Generator::Code';

sub generate_package_name {
	my $class = shift;
	my $namespace = shift;
	my $package_name = shift;
	return (defined $namespace ? $namespace."::" : "").$class->_convert_package_to_namespace($package_name);
}

sub generate_package {
	my $class = shift;
	my $namespace = shift;
	my $package_name = shift;
	my $full_package_name = $class->generate_package_name($namespace, $package_name);
	return qq {package $full_package_name;

use strict;
use warnings;

};
}

sub generate {
	my $class = shift;
	my $enum = shift;

	my $enum_string = "";
	if ($enum->{comment}) {
		foreach my $comment (@{$enum->{comment}}) {
			$enum_string .= "# $comment\n";
		}
	}

	$enum_string .= "use constant {\n";
	foreach my $value (@{$enum->{content}}) {
		my $comment = length($value->{comment}) > 0 ? "\t\t# $value->{comment}" : "";
		$enum_string .= "\t$value->{name} => $value->{value},$comment\n";
	}
	$enum_string .= "};";
	return $enum_string;
}

1;
