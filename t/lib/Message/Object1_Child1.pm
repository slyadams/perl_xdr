package Message::Object1_Child1;

use Moose;

extends 'Message';

has 'c1_uint16_1' => (is => 'rw', isa => 'uint16');
has 'c1_obj_c2' => (is => 'rw', isa => 'Message::Object1_Child2');
has 'c1_obj_c2s' => (is => 'rw', isa => 'ArrayRef[Message::Object1_Child2]');

__PACKAGE__->meta->make_immutable();

1;
