package Generator::Code;

use strict;
use warnings;

sub new {
	my $class = shift;
	my $namespace = shift;
	my $package_name = shift;
	my $object = shift;
	my $self = {
		namespace => $namespace,
		object => $object,
		use_packages => {},
	};
	bless($self, $class);
	$self->{package_name} = $self->_convert_package_to_namespace($package_name);
	return $self;
}

# Convert an xproto package name into a perl namespace, e.g. a.b -> a::b
sub _convert_package_to_namespace {
	my $class = shift;
	my $package = shift;
	$package =~ s/\./\:\:/ig;
	return $package;
}

sub generate_footer {
	my $class = shift;

	return qq{__PACKAGE__->meta->make_immutable();

1;};
}

sub _generate_package_name {
	my $class = shift;
	my $namespace = shift;
	my $package_name = shift;
	return "$namespace\:\:$package_name";
}


1;
