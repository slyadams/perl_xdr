package Generator;

use strict;
use warnings;

use Generator::Grammar;
use Generator::File;
use Generator::Parser;
use Generator::Code::Enum;
use Generator::Code::Object;

sub generate {
	my $class = shift;
	my $idl_file = shift;


	my $parser = Generator::Parser->get_parser();
	my $file = Generator::File->read_file($idl_file);
	$::RD_HINT   = 1;
	$::RD_WARN   = 1;
	$::RD_ERRORS = 1;

	$file =~ s/{/ {/gm;
	$file =~ s/}/ }/gm;
	$file =~ s/\[/ \[ /gm;
	$file =~ s/\]/ \] /gm;
	$file =~ s/;/ ;/gm;
	$file =~ s/^\s+}/}/gm;

	use Data::Dumper;
	my $data = $parser->File($file) or die "Cannot parse";
	
	chop($data->{package});
	my $namespace = $data->{package};
	$namespace =~ s/\./_/ig;


	# Produce enum file
	my $enums = Generator::Parser->get_enums($data);
	if (scalar @{$enums} > 0) {
		my $enum_string = Generator::Code::Enum->generate_package($namespace);
		foreach my $enum (@{$enums}) {
			$enum_string .= Generator::Code::Enum->generate($enum)."\n\n";
		}
		$enum_string .= "1;";
		print $enum_string."\n\n---------------------------------\n";
	}

	# Produce object files
	my $objects = Generator::Parser->get_objects($data);
	
	if (scalar @{$objects} > 0) {
		foreach my $def (@{$objects}) {
			my $object_string = Generator::Code::Object->generate_package($namespace, $def);
			$object_string .= Generator::Code::Object->generate($def)."\n";
			$object_string .= "1;";
			print $object_string."\n\n---------------------------------\n";
		}
	}

	return $data;
}

1;
