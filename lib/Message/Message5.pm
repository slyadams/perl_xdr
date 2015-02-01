package Message::Message5;

use Moose;

extends 'Message';
has 'version' => (is => 'ro', isa => 'uint16', default => '1');
has 'type' =>    (is => 'ro', isa => 'uint16', default => '3001');

has 'map' => (is => 'rw', isa => 'HashRef', traits => ["Mapped"], key_types => ["uint32", "uint32"] );

1;
