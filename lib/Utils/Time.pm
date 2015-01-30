package Utils::Time;

use Time::HiRes qw (gettimeofday);

sub get_time_usec {
	my $class = shift;
	my ($seconds, $microseconds) = gettimeofday;
	return $seconds*1000000+$microseconds;
}

1;
