package Generator;

use strict;
use warnings;

use Generator::Grammar;
use Generator::File;
use Generator::Parser;
use Generator::Code::Enum;
use Generator::Code::Object;
use Data::Dumper;

sub generate {
	my $class = shift;
	my $idl_file = shift;
	my $output_dir = shift;
	my $namespace = shift;

	if (! -f $idl_file) {
		die "GeneratorError: File '$idl_file' doesn't exist";
	}

	my $parser = Generator::Parser->get_parser();
	my $file = Generator::File->read_file($idl_file);
	my $output_files = {};
#	$::RD_TRACE  = 1;


	$file =~ s/{/ {/gm;
	$file =~ s/}/ }/gm;
	$file =~ s/\[/ \[ /gm;
	$file =~ s/\]/ \] /gm;
	$file =~ s/;/ ;/gm;
	$file =~ s/^\s+}/}/gm;

	my $data = $parser->File($file) or die "Cannot parse";
	chop($data->{package});
	my $package_name = $data->{package};

	# Produce enum file
	my $enums = Generator::Parser->get_enums($data);
	my $enum_package = {};
	if (scalar @{$enums} > 0) {
		foreach my $enum (@{$enums}) {
			my $enum_generator = new Generator::Code::Enum($namespace, $package_name, $enum);
			my $enum_string = $enum_generator->generate();
			$output_files->{$enum_generator->generate_package_name()} = $enum_string;
			$enum_package->{$enum->{name}} = $enum_generator->generate_package_name();
		}
	}

	# Produce object files
	my $objects = Generator::Parser->get_objects($data);
	my $lookup = Generator::Parser->get_name_lookup($data);
	if (scalar @{$objects} > 0) {
		foreach my $def (@{$objects}) {
			my $object_generator = new Generator::Code::Object($namespace, $package_name, $def);
			my $object_string = $object_generator->generate($lookup, $enum_package)."\n";
			$output_files->{$object_generator->generate_package_name()} = $object_string;
		}
	}

	# Write files
	my $success = 1;
	foreach my $file_name (keys %{$output_files}) {
		my $full_file_name = Generator::File->generate_file_name($output_dir, $file_name);
		my $result = Generator::File->write_file($full_file_name, $output_files->{$file_name});
		print sprintf("Creating %-50s: %s\n", $full_file_name, ($result == 1 ? "success" : "fail"));
		$success = $success && $result;
	
	}
	return $success;
}

1;
