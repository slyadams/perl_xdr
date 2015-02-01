package Message::Message1;

use Moose;

extends 'Message';

has 'version' => (is => 'ro', isa => 'uint16', default => '1');
has 'type' =>    (is => 'ro', isa => 'uint16', default => '1001');

has 'uint16' => (is => 'rw', isa => 'uint16');
has 'uint32' => (is => 'rw', isa => 'uint32');
has 'uint64' => (is => 'rw', isa => 'uint64');

1;
