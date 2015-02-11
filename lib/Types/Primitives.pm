package Types::Primitives;

use strict;
use warnings;

use constant templates => {
	"header_int"	=> "n",
	"uint16"	=> 'N',
	"int16"		=> 'N!',
	"uint32"	=> 'N',
	"int32"		=> 'N!',
	"uint64"	=> 'Q>',
	"int64"		=> 'q>',
	"float"		=> 'f>',
	"double"	=> 'd>',
	"bool"		=> 'N',
	"string"	=> 'N/a*',
	"bytes"		=> 'N/a*',
};

use constant defaults => {
	"header_int"	=> 0,
	"uint16"	=> 0,
	"int16"		=> 0,
	"uint32"	=> 0,
	"int32"		=> 0,
	"uint64"	=> 1,
	"int64"		=> 0,
	"float"		=> 0,
	"double"	=> 0,
	"bool"		=> 0,
	"string"	=> "1234",
	"bytes"		=> "",
};

sub get_template {
	my $self = shift;
	my $type = shift;

	return Types::Primitives->templates->{$type};
}

sub get_default {
	my $self = shift;
	my $type = shift;

	return Types::Primitives->defaults->{$type};
}

sub can {
	my $class = shift;
	my $type = shift;

	return defined $class->get_template($type);
}

sub encode {
	my $class = shift;
	my $type = shift;
	my $value = shift;
	if (!$class->can($type)) {
		print STDERR "Undefined primitive: '$type'\n";
	}	
	# Not using class methods for speed
	return pack(Types::Primitives->templates->{$type}, $value // Types::Primitives->defaults->{$type});
}

sub decode {
	my $class = shift;
	my $type = shift;
	my $data = shift;
	my $value;
	return unpack(Types::Primitives->templates->{$type}." a*", $data);
}

1;
