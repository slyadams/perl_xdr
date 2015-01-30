#!/usr/bin/perl

use lib '../lib/';
use Test::More;
use Test::Exception;

require_ok('MooseTest::Test');

my $m = new MooseTest::Test();

dies_ok { $m->int8(128)} 'big int8 dies';
dies_ok { $m->int8(0.5)} 'fractional int8 dies';
dies_ok { $m->int8(-129)} 'small int8 dies';

dies_ok { $m->uint8(256)} 'big int8 dies';
dies_ok { $m->uint8(0.5)} 'fractional int8 dies';
dies_ok { $m->uint8(-1)} 'small int8 dies';

dies_ok { $m->bool(2)} 'big bool dies';
dies_ok { $m->bool(0.5)} 'fractional bool dies';
dies_ok { $m->bool(-2)} 'negative bool dies';

