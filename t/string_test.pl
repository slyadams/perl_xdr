#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib/';
use lib 'lib/';
use Message;
use Test::More;
use Test::Deep;
use Message::Strings;
use Utils::Dumper;
use Data::Dumper;


$Message::message_lib_path = "lib/Message";

my $ref_data = {
          'version' => "1",
          'type' => "2",
          'string1' => "a\nb\tc",
          'string2' => "こんにちは",
          'string3' => "م\nر\tحبا",
};

my $m1 = new Message::Strings();
$m1->string1("a\nb\tc");
$m1->string2("こんにちは");
$m1->string3("م\nر\tحبا");

my $buffer1 = $m1->encode();
my $message_o1 = Message->decode($buffer1);

isa_ok ($m1, 'Message::Strings', "m1` class type");
is ($m1->string1(), "a\nb\tc", "m1 control characters");
is ($m1->string2(), "こんにちは", "m1 UTF8 characters");
is ($m1->string3(), "م\nر\tحبا", "m1 UTF8 with control characters");

is_deeply($ref_data, $m1->data(), 'message data equality type 1');
is_deeply($ref_data, Utils::Dumper->data($m1), 'message data equality type 2');
is_deeply(Utils::Dumper->data($m1), $m1->data(), 'message data equality type 3');

done_testing();
