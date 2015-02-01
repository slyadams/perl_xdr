#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib/';
require Message::Message1;
require Message::Message2;
require Message::Message3;
require Message::Message4;
require Message::Message5;
require Utils::Hex;
use Data::Dumper;

my $m1 = new Message::Message1();
my $m2 = new Message::Message2();
my $m3 = new Message::Message3();
my $m4 = new Message::Message4();
my $m5 = new Message::Message5();

$m1->uint16(1);
$m1->uint32(2);
$m1->uint64(3);


$m2->uint16(1);
$m2->uint32(2);
$m2->uint64(3);
$m2->int16(4);
$m2->int32(5);
$m2->int64(6);

$m1->_init();
my $buffer = $m1->encode();
print "Encoded:\n".Utils::Hex->dump($buffer)."\n";

my $m = Message->decode($buffer);
print $m->dump()."\n";
