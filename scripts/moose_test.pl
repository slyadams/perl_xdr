#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib/';
require Message::Message1;
require Message::Message2;
require Message::Message3;
require Utils::Hex;
use Data::Dumper;

my $m1 = new Message::Message1();
my $m2 = new Message::Message2();
my $m3 = new Message::Message3();
$m1->uint16(123);
$m1->uint32(123);
$m1->uint64(0);
$m2->uint16(1);
$m2->uint32(2);
$m2->uint64(3);
$m2->int16(4);
$m2->int32(5);
$m2->int64(6);
#$m3->bool(1);
#print "m1:".Dumper($m1->order2());
#print "m2:".Dumper($m2->order2());
#print "m3:".Dumper($m3->order());
#$m1->order2();


#print Dumper($m1->debug_order())."\n";
#print Dumper($m2->debug_order())."\n";
my $buffer = $m2->encode();
#print Dumper($m2->encode());
#print Dumper($m3->encode());
print Utils::Hex->dump($buffer);
