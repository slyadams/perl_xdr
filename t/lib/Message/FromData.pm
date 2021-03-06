package Message::FromData;

use Moose;
use Types;

extends 'Message';

has 'version' => (is => 'ro', isa => 'header_int', default => '1', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'type' =>    (is => 'ro', isa => 'header_int', default => '3', traits => ["DataType"], data_type => Types::PRIMITIVE);

has 'uint16' => (is => 'rw', isa => 'uint16', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'uint32' => (is => 'rw', isa => 'uint32', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'uint64' => (is => 'rw', isa => 'uint64', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'int16' => (is => 'rw', isa => 'int16', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'int32' => (is => 'rw', isa => 'int32', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'int64' => (is => 'rw', isa => 'int64', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'float' => (is => 'rw', isa => 'float', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'double' => (is => 'rw', isa => 'double', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'bool' => (is => 'rw', isa => 'bool', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'string' => (is => 'rw', isa => 'string', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'prim_array' => (is => 'rw', isa => 'ArrayRef[uint32]', traits => ["DataType"], data_type => Types::ARRAY);
has 'prim_hash' => (is => 'rw', isa => 'HashRef', traits => ["Mapped","DataType"], key_types => ["uint32", "uint32"], data_type => Types::MAP );
has 'child_1' => (is => 'rw', isa => 'Message::FromData1', traits => ["DataType"], data_type => Types::OBJECT);
has 'obj_array' => (is => 'rw', isa => 'ArrayRef[Message::FromData1]', traits => ["DataType"], data_type => Types::ARRAY);
has 'obj_hash' => (is => 'rw', isa => 'HashRef', traits => ["Mapped","DataType"], key_types => ["uint32", "Message::FromData1"], data_type => Types::MAP);

__PACKAGE__->meta->make_immutable();

1;
