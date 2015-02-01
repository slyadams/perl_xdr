package Message::Message4;

use Moose;

extends 'Message';

has 'version' => (is => 'ro', isa => 'uint16', default => '1');
has 'type' =>    (is => 'ro', isa => 'uint16', default => '2001');


has 'uint64' => (is => 'rw', isa => 'uint64');
has 'uint32s' => (is => 'rw', isa => 'ArrayRef[uint32]');
has 'strings' => (is => 'rw', isa => 'ArrayRef[string]');

1;
