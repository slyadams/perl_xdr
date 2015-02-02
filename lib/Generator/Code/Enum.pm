package Generator::Code::Enum;

use strict;
use warnings;

sub generate_package {
	my $class = shift;
	my $namespace = shift;
	return qq {
package $namespace;

use strict;
use warnings;

};
}

sub generate {
	my $class = shift;
	my $info = shift;
	my $enum = "use constant {\n";
	foreach my $e (@{$info->{content}}) {
		$enum .= "\t$e->{name} => $e->{value},\n";
	}
	$enum .= "};";
	return $enum;
}

1;
