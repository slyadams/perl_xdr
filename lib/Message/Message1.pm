package Message::Message1;

use Moose;

extends 'Message';

has 'version' => (is => 'ro', isa => 'header_int', default => '1', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'type' =>    (is => 'ro', isa => 'header_int', default => '10', traits => ["DataType"], data_type => Types::PRIMITIVE);

has 'uint16' => (is => 'rw', isa => 'uint16', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'uint32' => (is => 'rw', isa => 'uint32', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'uint64' => (is => 'rw', isa => 'uint64', traits => ["DataType"], data_type => Types::PRIMITIVE);

__PACKAGE__->meta->make_immutable();

1;
