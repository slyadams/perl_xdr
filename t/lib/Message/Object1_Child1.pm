package Message::Object1_Child1;

use Moose;
use Types;

extends 'Message';

has 'uint32' => (is => 'rw', isa => 'uint32', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'string' => (is => 'rw', isa => 'string', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'obj2' => (is => 'rw', isa => 'Message::Object1_Child2', traits => ["DataType"], data_type => Types::OBJECT);

__PACKAGE__->meta->make_immutable();

1;
