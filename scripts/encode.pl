#!/usr/bin/perl

use lib '../lib/';
use Utils::Time;
use Data::Dumper;

require Message::MessageA4;
require Utils::Dumper;
use Data::Dumper;

my $m4 = new Message::MessageA4();
$m4->uint16(1);
$m4->uint32(2);
$m4->uint64(3);
$m4->int16(4);
$m4->int32(5);
$m4->int64(6);
$m4->uint32s([21,22]);
$m4->uint16_2(10);
$m4->map({11 => 12, 13 => 14, 15 => 16});
$m4->uint16_3(17);

my $a = $m4->encode();

my $result = Message->decode($a, 1);
print Dumper($result);
