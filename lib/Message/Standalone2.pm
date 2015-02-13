package Message::Standalone2;

use Moose;

extends 'Message';

has 'sa2_uint16_1' => (is => 'rw', isa => 'uint16', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'sa2_uint16_2' => (is => 'rw', isa => 'uint16', traits => ["DataType"], data_type => Types::PRIMITIVE);

__PACKAGE__->meta->make_immutable();

1;
