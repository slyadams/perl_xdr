package Message::FromData1;

use Moose;

extends 'Message';

has 'uint32' => (is => 'rw', isa => 'uint32');
has 'prim_array' => (is => 'rw', isa => 'ArrayRef[uint32]');
has 'prim_hash' => (is => 'rw', isa => 'HashRef', traits => ["Mapped"], key_types => ["uint32", "uint32"] );

__PACKAGE__->meta->make_immutable();

1;
