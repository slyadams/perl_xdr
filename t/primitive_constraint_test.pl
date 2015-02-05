#!/usr/bin/perl

use lib '../lib/';
use lib 'lib/';
use Test::More;
use Test::Exception;

require_ok('Message::Simple');

my $m = new Message::Simple();

dies_ok { $m->int16(32768)} 	'too large int16 dies';
dies_ok { $m->int16(0.5)} 	'fractional int16 dies';
dies_ok { $m->int16(-32769)}	'too small int16 dies';
dies_ok { $m->uint16(65536)}	'too big uint16 dies';
dies_ok { $m->uint16(0.5)}	'fractional unt16 dies';
dies_ok { $m->uint16(-1)} 	'negative uint16 dies';

dies_ok { $m->int32(2147483648)} 	'too large int32 dies';
dies_ok { $m->int32(0.5)} 		'fractional int32 dies';
dies_ok { $m->int32(-2147483649)}	'too small int32 dies';
dies_ok { $m->uint32(4294967296)}	'too big uint32 dies';
dies_ok { $m->uint32(0.5)}		'fractional unt32 dies';
dies_ok { $m->uint32(-1)} 		'negative uint32 dies';

dies_ok { $m->int64(9223372036854775809)}	'too large int64 dies';
dies_ok { $m->int64(0.5)} 			'fractional int64 dies';
dies_ok { $m->int64(-9223372036854775809) }	'too small int64 dies';
dies_ok { $m->uint64(18446744073709551616)}	'too big uint64 dies';
dies_ok { $m->uint64(0.5)}			'fractional unt64 dies';
dies_ok { $m->uint64(-1)} 			'negative uint64 dies';

dies_ok { $m->bool(2)} 'big bool dies';
dies_ok { $m->bool(0.5)} 'fractional bool dies';
dies_ok { $m->bool(-2)} 'negative bool dies';


#has 'uint64' => (is => 'rw', isa => 'uint64');
#has 'int64' => (is => 'rw', isa => 'int64');

