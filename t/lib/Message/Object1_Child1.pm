package Message::Object1_Child1;

use Moose;
use Types;

extends 'Message';

has 'c1_uint16_1' => (is => 'rw', isa => 'uint16', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'c1_obj_c2' => (is => 'rw', isa => 'Message::Object1_Child2', traits => ["DataType"], data_type => Types::OBJECT);
has 'c1_obj_c2s' => (is => 'rw', isa => 'ArrayRef[Message::Object1_Child2]', traits => ["DataType"], data_type => Types::ARRAY);

__PACKAGE__->meta->make_immutable();

1;
