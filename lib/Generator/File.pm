package Generator::File;

use strict;
#use warnings;

use File::Slurp;

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

sub write_file {
	my $class = shift;
	my $file_name = shift;
	my $file_content = shift;

#	use Data::Dumper;
#	my @dirs = split('::', $file_name);
#	$file_name = pop @dirs;
#	print "File = $file_name";
#	print Dumper(\@dirs);
#die "stop";
	return File::Slurp::write_file($file_name, $file_content);
}

sub make_dir {
	my $class = shift;
	my $dir_name = shift;
	return mkdir($dir_name);
}

1;
