package Message::FromData1;

use Moose;
use Types;

extends 'Message';

has 'uint32' => (is => 'rw', isa => 'uint32', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'prim_array' => (is => 'rw', isa => 'ArrayRef[uint32]', traits => ["DataType"], data_type => Types::ARRAY);
has 'prim_hash' => (is => 'rw', isa => 'HashRef', traits => ["Mapped","DataType"], key_types => ["uint32", "uint32"], data_type => Types::PRIMITIVE );

__PACKAGE__->meta->make_immutable();

1;
