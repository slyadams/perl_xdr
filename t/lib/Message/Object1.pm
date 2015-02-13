package Message::Object1;

use Moose;
use Types;

extends 'Message';

use constant {
	ONE => 1,
	TWO => 2,
	THREE => 3,
};


has 'version' => (is => 'ro', isa => 'header_int', default => '1', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'type' =>    (is => 'ro', isa => 'header_int', default => '1', traits => ["DataType"], data_type => Types::PRIMITIVE);

has 'o1_uint16_1' => (is => 'rw', isa => 'uint16', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'o1_obj_c1' => (is => 'rw', isa => 'Message::Object1_Child1', traits => ["DataType"], data_type => Types::OBJECT);
has 'o1_obj_c2_h' => (is => 'rw', isa => 'HashRef', traits => ["Mapped","DataType"], key_types => ["uint32", "Message::Object1_Child2"], data_type => Types::OBJECT);
has 'o1_uint16_2' => (is => 'rw', isa => 'uint16', traits => ["DataType"], data_type => Types::PRIMITIVE);

__PACKAGE__->meta->make_immutable();

1;
