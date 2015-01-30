package Message::Message2;

use Moose;

extends 'Message::Message1';

has 'int8' => (is => 'rw', isa => 'int8');
has 'int16' => (is => 'rw', isa => 'int16');
has 'int32' => (is => 'rw', isa => 'int32');
has 'int64' => (is => 'rw', isa => 'int64');

1;
