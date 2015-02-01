package Message::MessageA2;

use Moose;

extends 'Message::MessageA1';

has '+type' =>    ( default => '4002');


has 'int16' => (is => 'rw', isa => 'int16');
has 'int32' => (is => 'rw', isa => 'int32');
has 'int64' => (is => 'rw', isa => 'int64');

1;
