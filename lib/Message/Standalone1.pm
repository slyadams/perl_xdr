package Message::Standalone1;

use Moose;

extends 'Message';

has 'uint16_sa' => (is => 'rw', isa => 'uint16');
has 'obj2' => (is => 'rw', isa => 'Message::Standalone2');
has 'obj2s' => (is => 'rw', isa => 'ArrayRef[Message::Standalone2]');

1;
