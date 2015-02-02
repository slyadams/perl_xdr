#!/usr/bin/perl

use lib '../lib/';
use strict;
use warnings;
$::RD_HINT = 1;

use Generator;
use Data::Dumper;

my $data = Generator->generate('../idl/auth.xproto');
