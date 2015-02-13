package Message::Object1_Child2;

use Moose;
use Types;

extends 'Message';

has 'c2_uint16_1' => (is => 'rw', isa => 'uint16', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'c2_uint16_2' => (is => 'rw', isa => 'uint16', traits => ["DataType"], data_type => Types::PRIMITIVE);

__PACKAGE__->meta->make_immutable();

1;
