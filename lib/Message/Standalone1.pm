package Message::Standalone1;

use Moose;

extends 'Message';

has 'sa1_uint16_1' => (is => 'rw', isa => 'uint16');
has 'sa1_obj_sa2' => (is => 'rw', isa => 'Message::Standalone2');
has 'sa1_obj_sa2s' => (is => 'rw', isa => 'ArrayRef[Message::Standalone2]');

__PACKAGE__->meta->make_immutable();

1;
