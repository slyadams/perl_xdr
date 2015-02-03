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
		die "File '$idl_file' doesn't exist";
	}
	if (! -d $output_dir) {
		if (!Generate::File->make_dir($output_dir)) {
			die "Couldn't create '$output_dir'";
		}
	}

	my $parser = Generator::Parser->get_parser();
	my $file = Generator::File->read_file($idl_file);
	my $output_files = {};
	$::RD_HINT   = 1;
	$::RD_WARN   = 1;
	$::RD_ERRORS = 1;
	#$::RD_TRACE  = 1;


	$file =~ s/{/ {/gm;
	$file =~ s/}/ }/gm;
	$file =~ s/\[/ \[ /gm;
	$file =~ s/\]/ \] /gm;
	$file =~ s/;/ ;/gm;
	$file =~ s/^\s+}/}/gm;

	my $data = $parser->File($file) or die "Cannot parse";
	
	chop($data->{package});
	my $package_name = $data->{package};
	$package_name =~ s/\./_/ig;

	#print Dumper($data);
	# Produce enum file
	my $enums = Generator::Parser->get_enums($data);
	if (scalar @{$enums} > 0) {
		my $enum_string = Generator::Code::Enum->generate_package($package_name, $namespace);
		foreach my $enum (@{$enums}) {
			$enum_string .= Generator::Code::Enum->generate($enum)."\n\n";
		}
		$enum_string .= "1;";
		$output_files->{Generator::Code::Enum->generate_package_name($package_name)} = $enum_string;
	}

	# Produce object files
	my $objects = Generator::Parser->get_objects($data);
	if (scalar @{$objects} > 0) {
		foreach my $def (@{$objects}) {
			my $object_string = Generator::Code::Object->generate_package($package_name, $namespace, $def, $def->{comment});
			$object_string .= Generator::Code::Object->generate($def)."\n";
			$object_string .= "1;";
			$output_files->{Generator::Code::Object->generate_package_name($package_name, $def)} = $object_string;
		}
	}

	# Write files
	my $success = 1;
	foreach my $file_name (keys %{$output_files}) {
		my $full_file_name = "$output_dir/$file_name.pm";
		my $result = Generator::File->write_file($full_file_name, $output_files->{$file_name});
		print sprintf("Creating %-50s: %s\n", $full_file_name, ($result == 1 ? "success" : "fail"));
		$success = $success && $result;
	
	}
	return $success;
}

1;
