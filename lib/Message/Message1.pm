package Message::Message1;

use Moose;

extends 'Message';

has 'uint8' => (is => 'rw', isa => 'uint8');
has 'uint16' => (is => 'rw', isa => 'uint16');
has 'uint32' => (is => 'rw', isa => 'uint32');
has 'uint64' => (is => 'rw', isa => 'uint64');

1;
