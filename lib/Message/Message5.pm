package Message::Message5;

use Moose;

extends 'Message';
has 'version' => (is => 'ro', isa => 'header_int', default => '1');
has 'type' =>    (is => 'ro', isa => 'header_int', default => '3001');

has 'map' => (is => 'rw', isa => 'HashRef', traits => ["Mapped"], key_types => ["uint32", "uint32"] );

__PACKAGE__->meta->make_immutable();

1;
