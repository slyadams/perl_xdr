package Generator::File;

use File::Slurp;

sub read_file {
	my $class = shift;
	my $file_name = shift;
	return File::Slurp::read_file($file_name);
}

sub write_file {
	my $class = shift;
	my $file_name = shift;

}

1;
