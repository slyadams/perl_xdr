#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib/';
use lib 'lib/';
use Test::More tests => 44;
use Test::Deep;
use Message;
use Message::FromData;
use Message::FromData1;
use Utils::Dumper;
use Data::Dumper;

my $ref_data = {
          'bool' => 1,
          'version' => 1,
          'int32' => -231,
          'string' => 'a string',
          'double' => '2.3',
          'uint32' => 141,
          'float' => '1.20000004768372',
          'uint16' => 5154,
          'int16' => -21,
          'int64' => 12313,
          'type' => 3,
          'uint64' => 1098141,
          'prim_array' => [1,3,5,7],
          'prim_hash' => { 1 => 2, 3 => 4},
          'child_1' => {
               'uint32' => 1,
               'prim_array' => [1,2,3,4],
               'prim_hash' => { 11 => 21, 31 => 41},
          },
          'obj_array' => [
               {
                    'uint32' => 2,
                    'prim_array' => [2,3,4,5],
                    'prim_hash' => { 12 => 22, 32 => 42},
               },
               {
                    'uint32' => 3,
                    'prim_array' => [3,4,5,6],
                    'prim_hash' => { 13 => 23, 33 => 43},
               },
               {
                    'uint32' => 4,
                    'prim_array' => [4,5,6,7],
                    'prim_hash' => { 14 => 24, 34 => 44},
               },
          ],
          'obj_hash' => {
               5 => {
                    'uint32' => 5,
                    'prim_array' => [5,6,7,8],
                    'prim_hash' => { 15 => 25, 35 => 45},
               },
               6 => {
                    'uint32' => 6,
                    'prim_array' => [6,7,8,9],
                    'prim_hash' => { 16 => 26, 36 => 46},
               },
          }
};

my $m = Message::FromData->from_data($ref_data);
isa_ok ($m, 'Message::FromData', "m class type");

is ($m->type(),3 , "type correct");
is ($m->bool(), 1, "bool correct");
is ($m->version(), 1, "version correct");
is ($m->int16(), -21, "int16 correct");
is ($m->int32(), -231, "int32 correct");
is ($m->int64(), 12313, "int64 correct");
is ($m->uint16(), 5154, "uint16 correct");
is ($m->uint32(), 141, "uint32 correct");
is ($m->uint64(), 1098141, "uint32 correct");
is ($m->double(), 2.3, "double correct");
is ($m->float(), 1.20000004768372, "float correct");
is ($m->string(), "a string", "string correct");
is_deeply ($m->prim_array, [1,3,5,7], "prim_array correct");
is_deeply ($m->prim_hash, { 1 => 2, 3 => 4}, "prim_hash correct");


isa_ok ($m->child_1(), 'Message::FromData1', "m->child_1() class type");
is ($m->child_1()->uint32(), 1, "m->child_1->uint32 correct");
is_deeply ($m->child_1()->prim_array(), [1,2,3,4], "m->child_1->prim_array correct");
is_deeply ($m->child_1()->prim_hash(), { 11 => 21, 31 => 41}, "m->child_1->prim_hash correct");


is (scalar @{$m->obj_array()}, 3, "m->obj_array length correct");
isa_ok ($m->obj_array()->[0], 'Message::FromData1', "m->obj_array->[0] class type");
is_deeply ($m->obj_array()->[0]->uint32(), 2, "m->obj_array->[0]->uint32 correct");
is_deeply ($m->obj_array()->[0]->prim_array(), [2,3,4,5], "m->obj_array->[0]->prim_array correct");
is_deeply ($m->obj_array()->[0]->prim_hash(), { 12 => 22, 32 => 42}, "m->obj_array->[0]->prim_hash correct");
isa_ok ($m->obj_array()->[1], 'Message::FromData1', "m->obj_array->[1] class type");
is_deeply ($m->obj_array()->[1]->uint32(), 3, "m->obj_array->[1]->uint32 correct");
is_deeply ($m->obj_array()->[1]->prim_array(), [3,4,5,6], "m->obj_array->[1]->prim_array correct");
is_deeply ($m->obj_array()->[1]->prim_hash(), { 13 => 23, 33 => 43}, "m->obj_array->[1]->prim_hash correct");
isa_ok ($m->obj_array()->[2], 'Message::FromData1', "m->obj_array->[2] class type");
is_deeply ($m->obj_array()->[2]->uint32(), 4, "m->obj_array->[2]->uint32 correct");
is_deeply ($m->obj_array()->[2]->prim_array(), [4,5,6,7], "m->obj_array->[2]->prim_array correct");
is_deeply ($m->obj_array()->[2]->prim_hash(), { 14 => 24, 34 => 44}, "m->obj_array->[2]->prim_hash correct");


is (scalar keys %{$m->obj_hash()}, 2, "m->obj_hash length correct");
isa_ok ($m->obj_hash()->{5}, 'Message::FromData1', "m->obj_hash->{5} class type");
is_deeply ($m->obj_hash()->{5}->uint32(), 5, "m->obj_hash->{5}->uint32 correct");
is_deeply ($m->obj_hash()->{5}->prim_array(), [5,6,7,8], "m->obj_hash->{5}->prim_array correct");
is_deeply ($m->obj_hash()->{5}->prim_hash(), { 15 => 25, 35 => 45}, "m->obj_hash->{5}->prim_hash correct");
isa_ok ($m->obj_hash()->{6}, 'Message::FromData1', "m->obj_hash->{6} class type");
is_deeply ($m->obj_hash()->{6}->uint32(), 6, "m->obj_hash->{6}6>uint32 correct");
is_deeply ($m->obj_hash()->{6}->prim_array(), [6,7,8,9], "m->obj_hash->{6}->prim_array correct");
is_deeply ($m->obj_hash()->{6}->prim_hash(), { 16 => 26, 36 => 46}, "m->obj_hash->{6}->prim_hash correct");


is_deeply($ref_data, $m->data(), 'message data equality type 1');
is_deeply($ref_data, Utils::Dumper->data($m), 'message data equality type 2');
is_deeply(Utils::Dumper->data($m), $m->data(), 'message data equality type 3');
