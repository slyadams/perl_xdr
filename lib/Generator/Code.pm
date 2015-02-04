package Generator::Code;

use strict;
use warnings;

sub generate_footer {
	my $class = shift;

	return qq{__PACKAGE__->meta->make_immutable();

1;};
}

1;
