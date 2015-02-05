package Generator::Grammar;

use strict;
use Data::Dumper;
use File::Slurp;

sub get_grammar {
	my $class = shift;
	return File::Slurp::read_file("../conf/grammar.conf");
}

1;
