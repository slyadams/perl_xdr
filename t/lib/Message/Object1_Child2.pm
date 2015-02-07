package Message::Object1_Child2;

use Moose;

extends 'Message';

has 'c2_uint16_1' => (is => 'rw', isa => 'uint16');
has 'c2_uint16_2' => (is => 'rw', isa => 'uint16');

__PACKAGE__->meta->make_immutable();

1;
