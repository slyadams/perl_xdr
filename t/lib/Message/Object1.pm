package Message::Object1;

use Moose;

extends 'Message';

use constant {
	ONE => 1,
	TWO => 2,
	THREE => 3,
};


has 'version' => (is => 'ro', isa => 'header_int', default => '1');
has 'type' =>    (is => 'ro', isa => 'header_int', default => '1');

has 'o1_uint16_1' => (is => 'rw', isa => 'uint16');
has 'o1_obj_c1' => (is => 'rw', isa => 'Message::Object1_Child1');
has 'o1_obj_c2_h' => (is => 'rw', isa => 'HashRef', traits => ["Mapped"], key_types => ["uint32", "Message::Object1_Child2"] );
has 'o1_uint16_2' => (is => 'rw', isa => 'uint16');

__PACKAGE__->meta->make_immutable();

1;
