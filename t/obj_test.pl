#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib/';
use lib 'lib/';
use Message;
use Test::More;
use Test::Deep;
use Message::Object1;
use Message::Object1_Child1;
use Message::Object1_Child2;
use Utils::Dumper;
use Data::Dumper;


my $ref_data = {
          'o1_obj_c2_h' => {
                             '4' => {
                                      'c2_uint16_1' => 8,
                                      'c2_uint16_2' => 12
                                    },
                             '3' => {
                                      'c2_uint16_1' => 6,
                                      'c2_uint16_2' => 9
                                    },
                             '5' => {
                                      'c2_uint16_1' => 10,
                                      'c2_uint16_2' => 15
                                    }
                           },
          'version' => 1,
          'o1_obj_c1' => {
                           'c1_uint16_1' => 2,
                           'c1_obj_c2s' => [
                                             {
                                               'c2_uint16_1' => 103,
                                               'c2_uint16_2' => 104
                                             },
                                             {
                                               'c2_uint16_1' => 105,
                                               'c2_uint16_2' => 106
                                             }
                                           ],
                           'c1_obj_c2' => {
                                            'c2_uint16_1' => 101,
                                            'c2_uint16_2' => 102
                                          }
                         },
          'type' => 1,
          'o1_uint16_1' => 1,
          'o1_uint16_2' => 3
        };

my $o1 = new Message::Object1();
my $c1_1 = new Message::Object1_Child1();

$c1_1->c1_uint16_1(2);
$c1_1->c1_obj_c2(new Message::Object1_Child2(c2_uint16_1 => 101, c2_uint16_2 => 102));
$c1_1->c1_obj_c2s([new Message::Object1_Child2(c2_uint16_1 => 103, c2_uint16_2 => 104),new Message::Object1_Child2(c2_uint16_1 => 105, c2_uint16_2 => 106)]);

$o1->o1_uint16_1(1);
$o1->o1_obj_c1($c1_1);
$o1->o1_obj_c2_h({	3 => new Message::Object1_Child2(c2_uint16_1 => 6, c2_uint16_2 => 9),
			4 => new Message::Object1_Child2(c2_uint16_1 => 8, c2_uint16_2 => 12),
			5 => new Message::Object1_Child2(c2_uint16_1 => 10, c2_uint16_2 => 15),
		});
$o1->o1_uint16_2(3);

my $buffer1 = $o1->encode();

my $message_o1 = Message->decode($buffer1);
isa_ok ($o1, 'Message::Object1', "o1 class type");
is ($message_o1->o1_uint16_1, 1, "o1.ol_uint16_1");
is ($message_o1->o1_uint16_2, 3, "o1.ol_uint16_2");

my $message_o1_c1 = $o1->o1_obj_c1();
isa_ok ($message_o1_c1, 'Message::Object1_Child1', "o1.o1_obj_c1 type");
is ($message_o1_c1->c1_uint16_1(), 2, "o1.o1_obj_cl.c1_uint16");
my $message_o1_c2 = $message_o1_c1->c1_obj_c2();
isa_ok ($message_o1_c2, 'Message::Object1_Child2', "o1.o1_obj_c1.c1_obj_c2 type");
is ($message_o1_c2->c2_uint16_1, 101, "o1.o1_obj_c1.c1_uint16_1");
is ($message_o1_c2->c2_uint16_2, 102, "o1.o1_obj_c1.c1_uint16_2");



my $message_o1_c2s = $message_o1_c1->c1_obj_c2s();
isa_ok ($message_o1_c2s, 'ARRAY', "o1.o1_obj_c1.c1_obj_c2s type");
is (scalar @{$message_o1_c2s}, 2, "o1.o1_obj_c1.c1_obj_c2s length");

for (my $i=0; $i<2; $i++) {
	my $message_c2 = $message_o1_c2s->[$i];
	isa_ok ($message_c2, 'Message::Object1_Child2', "o1.o1_obj_c1.c1_obj_c2s[$i] type");
	is ($message_c2->c2_uint16_1, 103+(2*$i), "o1.o1_obj_c1.c1_obj_c2s[$i].c1_uint16_1");
	is ($message_c2->c2_uint16_2, 104+(2*$i), "o1.o1_obj_c1.c1_obj_c2s[$i].c1_uint16_2");
}


my $message_o1_c2h = $message_o1->o1_obj_c2_h();
isa_ok ($message_o1_c2h, 'HASH', "o1.o1_obj_c2_h type");
is (scalar keys %{$message_o1_c2h}, 3, "o1.o1_obj_c2_h length");

for (my $key=3; $key <= 5; $key++) {
	my $message_c2 = $message_o1_c2h->{$key};
	isa_ok ($message_c2, 'Message::Object1_Child2', "o1.o1_obj_c2_h->{$key} type");
	is ($message_c2->c2_uint16_1, $key*2, "o1.o1_obj_c2_h->{$key}.cl_uint16_1");
	is ($message_c2->c2_uint16_2, $key*3, "o1.o1_obj_c2_h->{$key}.cl_uint16_2");
	
}

is_deeply($ref_data, $message_o1->data(), 'message data equality type 1');
is_deeply($ref_data, Utils::Dumper->data($message_o1), 'message data equality type 2');
is_deeply(Utils::Dumper->data($message_o1), $message_o1->data(), 'message data equality type 3');

done_testing();
