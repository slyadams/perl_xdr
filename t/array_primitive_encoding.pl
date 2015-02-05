#!/usr/bin/perl

use strict;
use warnings;
use lib '../lib/';
use lib 'lib/';
use Test::More;
use Test::Deep;
use Types::Array;

sub encode_decode {
	my $type = shift;
	my $value = shift;
	my @a = Types::Array->decode($type, Types::Array->encode($type, $value));
	return $a[0];
}

my $int16 =  [-3131,4,345,234,1,63536,1412,4101,-242];
my $uint16 = [3131,41412,4101,242,234,2875,948457,2];
my $int32 =  [-3131,41412,4101,-242,23525,-2365,26,62,-65262];
my $uint32 = [3131,41412,4101,242,34457,897549,32455];
my $int64 =  [-3131,41412,4101,-242,3567,-72727,82484,-8628181];
my $uint64 = [3131,41412,4101,242,235762572,24751216,171771];
my $bool  =  [1,1,1,0,1,0,1,01,0,1,0,0];

is_deeply (encode_decode("int16",  $int16),  $int16,  "int16 [] encoding");
is_deeply (encode_decode("uint16", $uint16), $uint16, "uint16 [] encoding");
is_deeply (encode_decode("int32",  $int32),  $int32,  "int32 [] encoding");
is_deeply (encode_decode("uint32", $uint32), $uint32, "uint32 [] encoding");
is_deeply (encode_decode("int64",  $int64),  $int64,  "int64 [] encoding");
is_deeply (encode_decode("uint64", $uint64), $uint64, "uint64 [] encoding");
is_deeply (encode_decode("bool", $bool), $bool, "bool [] encoding");
