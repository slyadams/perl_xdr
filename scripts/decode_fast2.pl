#!/usr/bin/perl

use strict;
use warnings;
use lib '../lib/';
use Data::Dumper;
use Utils::Dumper;

my $hex = "00 01 00 02 00 00 00 03 00 00 00 01 00 00 00 02 00 00 00 03 00 00 00 04";

$hex =~ s/\s*//ig;
my $buffer = pack("H*", $hex);
print "Buffer:\n".Utils::Dumper->hex($buffer)."\n";


#my $template = "n n (N/(N*)) N";
my $template = "n n (N/(N))";

#my @a = unpack($template, $buffer);
my ($a, $b, @c, $d) = unpack($template, $buffer);
#print Dumper(\@a);
print Dumper($a, $b, \@c, $d);
