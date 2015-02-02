package Message::MessageA4;

use Moose;

extends 'Message::MessageA3';

has '+type' =>    ( default => '4004');

has 'map' => (is => 'rw', isa => 'HashRef', traits => ["Mapped"], key_types => ["uint32", "uint32"] );
has 'uint16_3' => (is => 'rw', isa => 'uint16');

1;
