package Generator::Code;

use strict;
use warnings;

sub _convert_package_to_namespace {
	my $class = shift;
	my $package = shift;
	$package =~ s/\./_/ig;
	return $package;
}

sub generate_footer {
	my $class = shift;

	return qq{__PACKAGE__->meta->make_immutable();

1;};
}

1;
