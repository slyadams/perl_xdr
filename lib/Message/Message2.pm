package Message::Message2;

use Moose;

extends 'Message::Message1';

has '+type' => ( default => '1002');

has 'int16' => (is => 'rw', isa => 'int16');
has 'int32' => (is => 'rw', isa => 'int32');
has 'int64' => (is => 'rw', isa => 'int64');

__PACKAGE__->meta->make_immutable();

1;
