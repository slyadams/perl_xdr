#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib/';
require Message;
require Message::MessageB1;
require Message::Standalone1;
require Message::Standalone2;
require Utils::Dumper;
use Data::Dumper;

my $m1 = new Message::MessageB1();
my $sa1 = new Message::Standalone1();
my $sa2 = new Message::Standalone2();

$m1->uint16_a(Message::MessageB1->ONE);
$sa1->uint16_sa(2);
$sa2->uint16_sb(7);
$m1->uint16_b(3);

$m1->obj1($sa1);
$sa1->obj2($sa2);
$sa1->obj2s([$sa2,$sa2,$sa2]);

my $buffer1 = $m1->encode();
print "MessageB1:\n".Utils::Dumper->hex($buffer1)."\n";

my $ma = Message->decode($buffer1);
print Utils::Dumper->message($ma)."\n";
