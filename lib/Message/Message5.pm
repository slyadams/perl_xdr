package Message::Message5;

use Moose;

extends 'Message';

has 'map' => (is => 'rw', isa => 'HashRef', traits => ["Mapped"], key_types => ["uint32", "uint32"] );

1;
