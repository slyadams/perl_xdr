package Generator::File;

use strict;
#use warnings;

use File::Slurp;
use File::Path;

sub _strip_comments {
	my $class = shift;
	my $file = shift;
	return $file;
}

sub read_file {
	my $class = shift;
	my $file_name = shift;
	my $file = File::Slurp::read_file($file_name);
	return $class->_strip_comments($file);
}

# Write a file, creating paths as required
sub write_file {
	my $class = shift;
	my $file_name = shift;
	my $file_content = shift;
	if (index($file_name,"/") != -1) {
		my $path = substr($file_name, 0, rindex($file_name, "/"));
		File::Path::make_path($path);
	}
	return File::Slurp::write_file($file_name, $file_content);
}

# Convert a package name into a path, e.g. A::B::C -> A/B/C
sub generate_file_name {
	my $class = shift;
	my $output_dir = shift;
	my $file_name = shift;
	if (index($file_name, "::") == -1){
		return "$output_dir/$file_name.pm";
	} else {
		my $return_file_name = "$output_dir/$file_name.pm";
		$return_file_name =~ s/\:\:/\//ig;
		return $return_file_name;
	}

}

1;
