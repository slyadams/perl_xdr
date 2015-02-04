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
	"string"	=> 'N/A*',
	"bytes"		=> 'N/a*',

};

sub get_template {
	my $self = shift;
	my $type = shift;

	return Types::Primitives->templates->{$type};
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
		print "Undef: '$type'\n";
	}	
	return pack(Types::Primitives->templates->{$type}, $value);
}

sub decode {
	my $class = shift;
	my $type = shift;
	my $data = shift;
	my $value;
	return unpack(Types::Primitives->templates->{$type}." a*", $data);
}

1;
