#!/usr/bin/perl

use lib '../lib/';
use Utils::Time;

require Message::Message1;
require Message::Message2;
require Message::Message3;
my $m1 = new Message::Message1();
my $m2 = new Message::Message2();
my $m3 = new Message::Message3();
my $n=10000;

$m3->uint16(123);
$m3->uint32(123);
$m3->uint64(0);
$m3->int16(123);
$m3->int32(123);
$m3->int64(0);
$m3->bool(1);

$m2->uint16(123);
$m2->uint32(123);
$m2->uint64(0);
$m2->int16(123);
$m2->int32(123);
$m2->int64(0);

$m1->uint16(123);
$m1->uint32(123);
$m1->uint64(0);

$m2->_init();
my $a = $m2->encode();
Message->_load_messages();
my $start = Utils::Time->get_time_usec();

for (my $i=0; $i<$n; $i++) {
	my $m = Message->decode($a);
}

my $end = Utils::Time->get_time_usec();

print "Time: ".(($end-$start)/1000000)."s = ".($end-$start)/(1000*$n)."ms per decode\n";

