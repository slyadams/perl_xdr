package Message::MessageA3;

use Moose;

extends 'Message::MessageA2';

has '+type' =>    ( default => '4003');


has 'uint32s' => (is => 'rw', isa => 'ArrayRef[uint32]');
has 'uint16_2' => (is => 'rw', isa => 'uint16');

1;
