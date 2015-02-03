#!/usr/bin/perl

use lib '../lib/';
use strict;
use warnings;
$::RD_HINT = 1;

use Generator;
use Data::Dumper;
use Getopt::Std;

my $usage = "generate.pl -i <input IDL file> -o <output directory>";

my $opts = { 
	"o" => "build/" ,
	"n" => "Message",
};
getopts('i:o:n:', $opts);
if (!defined $opts->{i}) {
	print $usage."\n";
	exit(-1);
}

my $data = Generator->generate($opts->{i}, $opts->{o}, $opts->{n});
