package Message::MessageB1;

use Moose;
#use Moose::Util::TypeConstraints qw (class_type);

extends 'Message';

#class_type 'Standalone1', {
#        class => 'Message::Standalone1'
#};


has 'version' => (is => 'ro', isa => 'uint16', default => '1');
has 'type' =>    (is => 'ro', isa => 'uint16', default => '5001');

has 'uint16_a' => (is => 'rw', isa => 'uint16');
has 'obj1' => (is => 'rw', isa => 'Message::Standalone1');
has 'uint16_b' => (is => 'rw', isa => 'uint16');

1;
