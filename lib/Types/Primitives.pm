package Types::Primitives;

use strict;
use warnings;

use constant templates => {
	"uint8"		=> 'N',
	"int8"		=> 'N!',

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

#                'byte' => 'N/a*',
#        };

};

sub can {
	my $class = shift;
	my $type = shift;
	return exists Types::Primitives->templates->{$type};
}

sub encode {
	my $class = shift;
	my $type = shift;
	my $value = shift;
	if (!defined $value) {
		print "Undef: $type\n";
	}	
	return pack(Types::Primitives->templates->{$type}, $value);
}

sub decode {
	my $class = shift;
	my $type = shift;
	my $data = shift;
	return unpack(Types::Primitives->templates->{$type}, $data);
}

1;
