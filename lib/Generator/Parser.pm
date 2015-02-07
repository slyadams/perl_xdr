package Generator::Parser;

use Parse::RecDescent;
use Generator::Grammar;

sub get_parser {
	my $class = shift;

	my $grammar = Generator::Grammar->get_grammar();
	my $parser = Parse::RecDescent->new($grammar) or die "Grammar error";
	return $parser 
}

sub _get_by_type {
	my $class = shift;
	my $info = shift;
	my $type = shift;
	my @e = map { $_->{type} eq $type ? $_ : () } @{$info->{definitions}};
	return \@e;
}

sub get_enums {
	my $class = shift;
	my $info = shift;
	return $class->_get_by_type($info, "enum");
}

sub get_objects {
	my $class = shift;
	my $info = shift;
	return $class->_get_by_type($info, "object");
}

sub get_name_lookup {
#sub get_name_summary {
	my $class = shift;
	my $config = shift;
	my $new_config = {};
	foreach my $def (@{$config->{definitions}}) {
		if ($def->{type} eq "enum" || $def->{type} eq "object") {
			$new_config->{$def->{name}} = $def;
		}
	}
	return $new_config;
}

1;
