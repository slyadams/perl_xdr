package Types;

use strict;
use warnings;

use constant templates => {
	"uint8"		=> 'N',
	"int8"		=> 'l',

	"uint16"	=> 'N',
	"int16"		=> 'l',

	"uint32"	=> 'N',
	"int32"		=> 'l',

	"uint64"	=> 'Q',
	"int64"		=> 'q',

	"float"		=> 'f>',
	"double"	=> 'd>',

	"bool"		=> 'N',
	"string"	=> 'N/A*',
	"bytes"		=> 'N/a*',

#        return {
#                'uint16' => 'n',
#                'int16' => 'N!',
#                'uint32' => 'N',
#                'int32' => 'N!',
#                'byte' => 'N/a*',
#        };

};

sub encode {
	my $class = shift;
	my $type = shift;
	my $value = shift;
	if (!defined $value) {
		print "Undef: $type\n";
	}	
	return pack(Types->templates->{$type}, $value);
}

sub decode {
	my $class = shift;
	my $type = shift;
	my $data = shift;
	return unpack(Types->templates->{$type}, $data);
}

1;
