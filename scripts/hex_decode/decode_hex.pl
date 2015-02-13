#!/usr/bin/perl

use lib '../../lib/';
use lib '../generator/build/';
use Message;
use File::Slurp;
use Utils::Dumper;
use Data::Dumper;

my $directory = $ARGV[0];

foreach my $file (sort <$directory/*.hex>) {
	print "Evaluating $file\n";
	my $file_content = File::Slurp::read_file($file);
	$file_content =~ s/\s*//ig;
	my $buffer = pack("H*",$file_content);
	if ($file =~ m/sent/ig) {
		my $length;
		($length, $buffer) = unpack("N a*", $buffer);
	}
	eval {
		#my $m = Message->decode($buffer);
		#print Utils::Dumper->message($m);
		my $m = Message->decode_data($buffer);
		print Dumper($m);
	};
	if ($@) {
		print "Error: $@\n";
	}
	print "--------------------------------------------------\n";
}
