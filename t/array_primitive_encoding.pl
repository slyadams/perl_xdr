#!/usr/bin/perl

use strict;
use warnings;
use lib '../lib/';
use lib 'lib/';
use Test::More;
use Test::Deep;
use Types::Array;
use Data::Dumper;
use Random;

sub encode_decode {
	my $type = shift;
	my $value = shift;
	my @a = Types::Array->decode($type, Types::Array->encode($type, $value));
	return $a[0];
}

sub make_array {
	my $n = shift;
	my $type = shift;
	my $width = shift;
	my @array = ();
	for (my $i=0; $i<$n; $i++) {
		if ($type eq "uint") {
			push(@array, Random->uint($width));
		} else {
			push(@array, Random->int($width));
		}
	}
	return \@array;
}

my $n = 25;
for (my $i=0; $i<$n; $i++) {
	foreach my $type ("int", "uint") {
		foreach my $width (16, 32, 64) {
			my $data_type = "$type$width";
			my $array = make_array(Random->uint(8), $type, $width);
			is_deeply( encode_decode($data_type, $array), $array, "$data_type array iter $i" );
		}
	}
}

