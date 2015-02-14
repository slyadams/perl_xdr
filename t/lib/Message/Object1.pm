package Message::Object1;

use Moose;
use Types;

extends 'Message';

has 'version' => (is => 'ro', isa => 'header_int', default => '1', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'type' =>    (is => 'ro', isa => 'header_int', default => '1', traits => ["DataType"], data_type => Types::PRIMITIVE);

has 'uint32' => (is => 'rw', isa => 'uint32', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'obj1' => (is => 'rw', isa => 'Message::Object1_Child1', traits => ["DataType"], data_type => Types::OBJECT);
has 'obj2' => (is => 'rw', isa => 'Message::Object1_Child2', traits => ["DataType"], data_type => Types::OBJECT);
has 'obj1_a' => (is => 'rw', isa => 'ArrayRef[Message::Object1_Child1]', traits => ["DataType"], data_type => Types::ARRAY);
has 'obj1_h' => (is => 'rw', isa => 'HashRef', traits => ["Mapped", "DataType"], key_types => ["uint32", "Message::Object1_Child1"], data_type => Types::MAP);
has 'obj2_a' => (is => 'rw', isa => 'ArrayRef[Message::Object1_Child2]', traits => ["DataType"], data_type => Types::ARRAY);
has 'obj2_h' => (is => 'rw', isa => 'HashRef', traits => ["Mapped", "DataType"], key_types => ["uint32", "Message::Object1_Child2"], data_type => Types::MAP);

__PACKAGE__->meta->make_immutable();

1;
