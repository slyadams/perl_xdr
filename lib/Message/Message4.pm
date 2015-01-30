package Message::Message4;

use Moose;

extends 'Message';

has 'uint64' => (is => 'rw', isa => 'uint64');
has 'uint32s' => (is => 'rw', isa => 'ArrayRef[uint32]');
has 'strings' => (is => 'rw', isa => 'ArrayRef[string]');

1;
