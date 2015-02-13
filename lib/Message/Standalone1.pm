package Message::Standalone1;

use Moose;

extends 'Message';

has 'sa1_uint16_1' => (is => 'rw', isa => 'uint16', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'sa1_obj_sa2' => (is => 'rw', isa => 'Message::Standalone2', traits => ["DataType"], data_type => Types::OBJECT);
has 'sa1_obj_sa2s' => (is => 'rw', isa => 'ArrayRef[Message::Standalone2]', traits => ["DataType"], data_type => Types::ARRAY);

__PACKAGE__->meta->make_immutable();

1;
