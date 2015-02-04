#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib/';
require Message;
require Message::MessageC;
require Utils::Dumper;
use Data::Dumper;

my $m1 = new Message::MessageC();
$m1->uint32(1);
$m1->uint32s([2,3,4]);

my $buffer = $m1->encode();
print "Message:\n".Utils::Dumper->hex($buffer)."\n";

my $ma = Message->decode_fast($buffer);
print Dumper($ma)."\n";

