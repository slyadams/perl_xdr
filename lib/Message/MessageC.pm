package Message::MessageC;

use Moose;

extends 'Message';

has 'version' => (is => 'ro', isa => 'header_int', default => '1');
has 'type' =>    (is => 'ro', isa => 'header_int', default => '6001');

has 'uint32' => (is => 'rw', isa => 'uint32');
has 'uint32s' => (is => 'rw', isa => 'ArrayRef[uint32]');

__PACKAGE__->meta->make_immutable();

1;
