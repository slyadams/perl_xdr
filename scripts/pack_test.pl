#!/usr/bin/perl

use lib '../lib/';
use Data::Dumper;

require Types;
require Types::Array;
require Types::Map;
require Utils::Hex;

my $hash = {
	"a" => "simon",
	"b" => "adams",
};
my $hash2 = {
	1 => 2,
	2 => 3,
	3 => 4,
};

#print Dumper(Types::Array->decode("string", Types::Array->encode("string", ["12","25","4","12","simon"])))."\n";
print Dumper(Types::Map->decode("uint32", "uint32", Types::Map->encode("uint32", "uint32", $hash2)));
print Dumper(Types::Map->decode("string", "string", Types::Map->encode("string", "string", $hash)));
