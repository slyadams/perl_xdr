package Message::Message2;

use Moose;

extends 'Message::Message1';

has '+type' => ( default => '20');

has 'int16' => (is => 'rw', isa => 'int16', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'int32' => (is => 'rw', isa => 'int32', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'int64' => (is => 'rw', isa => 'int64', traits => ["DataType"], data_type => Types::PRIMITIVE);

__PACKAGE__->meta->make_immutable();

1;
