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

my $b1 = new Message::MessageB1();
my $sa1 = new Message::Standalone1();
my $sa2 = new Message::Standalone2();


$sa2->sa2_uint16_1(7);
$sa2->sa2_uint16_2(8);

$sa1->sa1_uint16_1(2);
$sa1->sa1_obj_sa2($sa2);
$sa1->sa1_obj_sa2s([$sa2]);

$b1->b_uint16_1(1);
$b1->b_obj_sa1($sa1);
$b1->b_obj_sa2_h({3=>$sa2, 4=>$sa2});
$b1->b_uint16_2(3);

my $buffer1 = $b1->encode();
print "MessageB1:\n".Utils::Dumper->hex($buffer1)."\n";

#my $ma = Message->decode($buffer1);
#print "Message:\n".Utils::Dumper->message($ma)."\n";

$Data::Dumper::Deepcopy = 1;
print Dumper(Message->decode($buffer1, 1));
