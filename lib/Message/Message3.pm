package Message::Message3;

use Moose;

extends 'Message::Message2';

has '+type' => (default => '30');

has 'bool' => (is => 'rw', isa => 'bool', traits => ["DataType"], data_type => Types::PRIMITIVE);

__PACKAGE__->meta->make_immutable();

1;
