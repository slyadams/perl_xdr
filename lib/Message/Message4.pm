package Message::Message4;

use Moose;

extends 'Message';

has 'version' => (is => 'ro', isa => 'header_int', default => '1');
has 'type' =>    (is => 'ro', isa => 'header_int', default => '2001');


has 'uint64' => (is => 'rw', isa => 'uint64');
has 'uint32s' => (is => 'rw', isa => 'ArrayRef[uint32]');
has 'strings' => (is => 'rw', isa => 'ArrayRef[string]');

__PACKAGE__->meta->make_immutable();

1;
