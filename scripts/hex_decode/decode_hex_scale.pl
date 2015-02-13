#!/usr/bin/perl

use lib '../../lib/';
use lib '../generator/build/';
use Message;
use File::Slurp;
use Utils::Time;

my $file = $ARGV[0];
my $n = $ARGV[1] // 1000;
my $mode = $ARGV[2] // 1;

Message->_init();
print "Decoding $file\n";
my $file_content = File::Slurp::read_file($file);
$file_content =~ s/\s*//ig;
my $buffer1 = pack("H*",$file_content);
	
my $start = Utils::Time->get_time_usec();

for (my $i=0; $i<$n; $i++) {
	if ($mode == 1) {
		Message->decode_data($buffer1);
	} else {
		Message->decode($buffer1);
	}
}
my $end = Utils::Time->get_time_usec();

print "Time: ".(($end-$start)/1000000)."s = ".($end-$start)/(1000*$n)."ms per decode\n";
