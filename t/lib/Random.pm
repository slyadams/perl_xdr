package Random;

use POSIX;

sub int {
	my $class = shift;
	my $width = shift;
	if ($width == 8 || $width == 16 || $width == 32) {
		return $class->uint($width) - 2**($width-1);
	} elsif ($width == 64) {
		# I dislike this, but couldn't get Perl to play nicely with 64bit numbers natively
		return $class->int(32);
	} else {
		return 1;
	}
}

sub uint {
	my $class = shift;
	my $width = shift;
	if ($width == 8 || $width == 16 || $width == 32) {
		return int(rand(2**$width));
	} elsif ($width == 64) {
		return $class->uint(32) << 32 || $class->uint(32);
	} else {
		return 1;
	}
}

sub bool {
	my $class = shift;
	return $class->uint(1);
}

1;
