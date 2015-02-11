package Message::FromData;

use Moose;

extends 'Message';

has 'version' => (is => 'ro', isa => 'header_int', default => '1');
has 'type' =>    (is => 'ro', isa => 'header_int', default => '3');

has 'uint16' => (is => 'rw', isa => 'uint16');
has 'uint32' => (is => 'rw', isa => 'uint32');
has 'uint64' => (is => 'rw', isa => 'uint64');
has 'int16' => (is => 'rw', isa => 'int16');
has 'int32' => (is => 'rw', isa => 'int32');
has 'int64' => (is => 'rw', isa => 'int64');
has 'float' => (is => 'rw', isa => 'float');
has 'double' => (is => 'rw', isa => 'double');
has 'bool' => (is => 'rw', isa => 'bool');
has 'string' => (is => 'rw', isa => 'string');
has 'prim_array' => (is => 'rw', isa => 'ArrayRef[uint32]');
has 'prim_hash' => (is => 'rw', isa => 'HashRef', traits => ["Mapped"], key_types => ["uint32", "uint32"] );
has 'child_1' => (is => 'rw', isa => 'Message::FromData1');
has 'obj_array' => (is => 'rw', isa => 'ArrayRef[Message::FromData1]');
has 'obj_hash' => (is => 'rw', isa => 'HashRef', traits => ["Mapped"], key_types => ["uint32", "Message::FromData1"] );

__PACKAGE__->meta->make_immutable();

1;
