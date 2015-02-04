#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib/';
use Utils::Time;
require Message;
require Message::MessageB1;
require Message::Standalone1;
require Message::Standalone2;
require Utils::Dumper;
use Data::Dumper;

my $n=1000;

my $b1 = new Message::MessageB1();
my $sa1 = new Message::Standalone1();
my $sa2 = new Message::Standalone2();
$b1->_init();


$b1->b_uint16_1(1);
$b1->b_uint16_2(3);

$sa1->sa1_uint16_1(2);
$sa2->sa2_uint16_1(7);
$sa2->sa2_uint16_2(8);

$b1->b_obj_sa1($sa1);

$sa1->sa1_obj_sa2($sa2);
$sa1->sa1_obj_sa2s([$sa2,$sa2,$sa2,$sa2]);
$b1->b_obj_sa2_h({3=>$sa2, 4=>$sa2});

my $buffer1 = $b1->encode();

my $mode = $ARGV[0] // 1;
my $start = Utils::Time->get_time_usec();

for (my $i=0; $i<$n; $i++) {
	my $ma = Message->decode($buffer1, $mode);
}

my $end = Utils::Time->get_time_usec();

print "Time: ".(($end-$start)/1000000)."s = ".($end-$start)/(1000*$n)."ms per decode\n";
