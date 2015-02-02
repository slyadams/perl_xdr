#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib/';
require Message;
require Message::MessageA1;
require Message::MessageA2;
require Message::MessageA3;
require Message::MessageA4;
require Utils::Dumper;
use Data::Dumper;

my $m1 = new Message::MessageA1();
my $m2 = new Message::MessageA2();
my $m3 = new Message::MessageA3();
my $m4 = new Message::MessageA4();
$m1->uint16(1);
$m1->uint32(2);
$m1->uint64(3);
$m2->uint16(1);
$m2->uint32(2);
$m2->uint64(3);
$m2->int16(4);
$m2->int32(5);
$m2->int64(6);
$m3->uint16(1);
$m3->uint32(2);
$m3->uint64(3);
$m3->int16(4);
$m3->int32(5);
$m3->int64(6);
$m3->uint32s([7,8,9]);
$m3->uint16_2(10);
$m4->uint16(1);
$m4->uint32(2);
$m4->uint64(3);
$m4->int16(4);
$m4->int32(5);
$m4->int64(6);
$m4->uint32s([7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22]);
$m4->uint16_2(10);
$m4->map({11 => 12, 13 => 14, 15 => 16});
$m4->uint16_3(17);

my $buffer1 = $m1->encode();
print "MessageA1:\n".Utils::Dumper->hex($buffer1)."\n";
my $buffer2 = $m2->encode();
print "MessageA2:\n".Utils::Dumper->hex($buffer2)."\n";
my $buffer3 = $m3->encode();
print "MessageA3:\n".Utils::Dumper->hex($buffer3)."\n";
my $buffer4 = $m4->encode();
print "MessageA4:\n".Utils::Dumper->hex($buffer4)."\n";

my $ma = Message->decode($buffer1);
print Utils::Dumper->message($ma)."\n";

my $mb = Message->decode($buffer2);
print Utils::Dumper->hex($mb)."\n";

my $mc = Message->decode($buffer3);
print Utils::Dumper->hex($mc)."\n";

my $md = Message->decode($buffer4);
print Utils::Dumper->hex($md)."\n";
