#!/usr/bin/perl

use strict;
use warnings;
use lib '../lib/';
use lib 'lib/';
use Test::More;
use Test::Deep;
use Types::Primitives;

sub encode_decode {
	my $type = shift;
	my $value = shift;
	return Types::Primitives->decode($type, Types::Primitives->encode($type, $value));
}

is (encode_decode("int16",  119), 119,  "int16 encoding");
is (encode_decode("int16", -291), -291, "int16 negative encoding");
is (encode_decode("uint16", 119), 119,  "uint16 encoding");
is (encode_decode("int32",  23123), 23123,   "int32 encoding");
is (encode_decode("int32", -20991), -20991,  "int32 negative encoding");
is (encode_decode("uint32", 839119), 839119, "uint32 encoding");
is (encode_decode("int64",  1230491407), 1230491407,  "int64 encoding");
is (encode_decode("int64", -2133492397), -2133492397, "uint64 encoding");
is (encode_decode("uint64", 213431591),  213431591,   "uint64 negative encoding");
is (encode_decode("bool", 1), 1, "bool true encoding");
is (encode_decode("bool", 0), 0, "bool false encoding");

my $a = encode_decode("float", 849240.234024);
my $b = encode_decode("float", -849240.234024);
my $c = encode_decode("double", 9822349240.2134);
my $d = encode_decode("double", -9822349240.2134);
cmp_deeply ($a, num(849240.234024,0.25), "float encoding");
cmp_deeply ($b, num(-849240.234024,0.25), "float negative encoding");
cmp_deeply ($c, num(9822349240.2134), "double encoding");
cmp_deeply ($d, num(-9822349240.2134), "double negative encoding");

done_testing();
