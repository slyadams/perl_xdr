#!/usr/bin/perl

use strict;
use warnings;
use lib '../lib/';
use lib 'lib/';
use Test::More tests => 150;
use Test::Deep;
use Types::Map;
use Random;

sub encode_decode {
	my $key_type = shift;
	my $value_type = shift;
	my $value = shift;
	my @a = Types::Map->decode($key_type, $value_type, Types::Map->encode($key_type, $value_type, $value));
	return $a[0];
}

sub make_hash {
	my $n = shift;
	my $type = shift;
	my $width = shift;

	my $hash = {};
	for (my $i=0; $i<$n; $i++) {
		if ($type eq "uint") { 
			$hash->{Random->uint($width)} = Random->uint($width);
		} else {
			$hash->{Random->int($width)} = Random->int($width);
		}
	}
	return $hash;
}

my $n = 25;
for (my $i=0; $i<$n; $i++) {
	foreach my $type ("int", "uint") {
		foreach my $width (16, 32, 64) {
			my $data_type = "$type$width";
			my $hash = make_hash(Random->uint(8), $type, $width);
			is_deeply( encode_decode($data_type, $data_type, $hash), $hash, "$data_type map iter $i" );
		}
	}
}
