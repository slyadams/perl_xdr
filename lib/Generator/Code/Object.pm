package Generator::Code::Object;

use strict;
use warnings;

sub generate_package {
	my $class = shift;
	my $namespace = shift;
	my $package = shift;

	return qq {
package $namespace\_$package->{name};

use strict;
use warnings;
use Moose;

extends 'Message';

};
}

sub generate {
	my $self = shift;
	my $info = shift;

	my $field_string = "";
	foreach my $f (@{$info->{content}}) {
		$field_string .= "has '$f->{name}' => (is => 'ro', isa => '$f->{data_type}',";
		if ($f->{type} eq "option") {
			$field_string .= " default => '$f->{value},";
		} elsif ($f->{type} eq "required") {
			
		}
		chop($field_string);
		$field_string .= ");\n";
	}
	return $field_string;
}

1;
