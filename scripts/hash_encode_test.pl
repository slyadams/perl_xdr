#!/usr/bin/perl

use lib '../lib/';
use Message;
use Message::Message5;
use Utils::Dumper;
use Data::Dumper;
use strict;
use warnings;

my $m5 = new Message::Message5(map => { 7 => 5, 8 => 9} );

my $buffer = $m5->encode();
print Utils::Dumper->hex($buffer)."\n";

my $m = Message->decode($buffer);
print Utils::Dumper->message($m);
