#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib/';
use lib 'lib/';
use Message;
use Message::Object1;
use Message::Object1_Child1;
use Message::Object1_Child2;
use Test::More;
use Test::Deep;
use Utils::Dumper;
use Data::Dumper;

my $index = 0;

sub gen_bool {
	my $integer = shift;
	return $integer % 2;
}

sub gen_obj2 {
	$index++;
	return new Message::Object1_Child2(uint32 => $index, bool => gen_bool($index), string => $index);
}

sub gen_obj1 {
	$index++;
	my $o = new Message::Object1_Child1(uint32 => $index, string => $index);
	$o->obj2(gen_obj2());
	return $o;
}

sub check_obj2 {
	my $o = shift;
	$index++;
	is ($o->uint32(), $index, "check o2.uint32 $index");
	is ($o->bool(), gen_bool($index), "check o2.bool $index");
	is ($o->string(), $index, "check o2.string $index");
}

sub check_obj1 {
	my $o = shift;
	$index++;
	is ($o->uint32(), $index, "check o1.uint32 $index");
	is ($o->string(), $index, "check o1.string $index");
	check_obj2($o->obj2);
}

####### Generate data
my $o = new Message::Object1(uint32 => ++$index);
$o->obj1(gen_obj1());
$o->obj2(gen_obj2());

my @o1_a = ();
for (my $i=0; $i<30; $i++) {
	push(@o1_a, gen_obj1());
}
$o->obj1_a(\@o1_a);

my %o1_h = ();
for (my $i=0; $i<40; $i++) {
	my $o1 = gen_obj1();
	$o1_h{$o1->uint32()} = $o1;
}
$o->obj1_h(\%o1_h);

my @o2_a = ();
for (my $i=0; $i<50; $i++) {
	push(@o2_a, gen_obj2());
}
$o->obj2_a(\@o2_a);

my %o2_h = ();
for (my $i=0; $i<60; $i++) {
	my $o2 = gen_obj2();
	$o2_h{$o2->uint32()} = $o2;
}
$o->obj2_h(\%o2_h);

my $buffer = $o->encode();
my $m = Message->decode($buffer);

####### Test
$index = 0;

isa_ok( $m, "Message::Object1", '$m class correct');
is( $m->uint32(), ++$index, '$m->uint32() correct');
check_obj1($m->obj1());
check_obj2($m->obj2());

my $o1_a = $m->obj1_a();
is( scalar @{$o1_a}, 30, 'length $m->o1_a');
foreach my $o1 (@{$o1_a}) {
	check_obj1($o1);
}


my $o1_h = $m->obj1_h();
is( scalar keys %{$o1_h}, 40, 'length $m->o1_h');
foreach my $key (sort {$a <=> $b} keys %{$o1_h}) {
	check_obj1($o1_h->{$key});
}

my $o2_a = $m->obj2_a();
is( scalar @{$o2_a}, 50, 'length $m->o2_a');
foreach my $o2 (@{$o2_a}) {
	check_obj2($o2);
}

my $o2_h = $m->obj2_h();
is( scalar keys %{$o2_h}, 60, 'length $m->o2_h');
foreach my $key (sort {$a <=> $b} keys %{$o2_h}) {
	check_obj2($o2_h->{$key});
}

is_deeply($m->data(), Message->decode_data($buffer), 'message data equality');

done_testing();
