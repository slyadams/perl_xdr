#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib/';
require Message::Message4;
require Utils::Hex;
use Data::Dumper;

my $m4 = new Message::Message4();
$m4->uint64(1);
$m4->uint32s([2,3,4]);
$m4->strings(["abc","efg"]);
my $buffer = $m4->encode();
print Utils::Hex->dump($buffer);
