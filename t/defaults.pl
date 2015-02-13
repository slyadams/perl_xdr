#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib/';
use lib 'lib/';
use Message;
use Message::Defaults;
use Test::More;
use Utils::Dumper;
use Data::Dumper;

my $m = new Message::Defaults();
my $buffer1 = $m->encode();
my $ma = Message->decode($buffer1);

is ($ma->int16(), 0, 'int16 default');
is ($ma->int32(), 0, 'int32 default');
is ($ma->int64(), 0, 'int64 default');
is ($ma->uint16(), 0, 'uint16 default');
is ($ma->uint32(), 0, 'uint32 default');
is ($ma->uint64(), 0, 'uint64 default');
is ($ma->float(), 0, 'float default');
is ($ma->double(), 0, 'double default');
is ($ma->bool(), 0, 'bool default');
is ($ma->string(), "", 'string default');

done_testing();
