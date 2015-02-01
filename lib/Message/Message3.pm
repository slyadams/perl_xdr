package Message::Message3;

use Moose;

extends 'Message::Message2';

has '+type' => (default => '1003');

has 'bool' => (is => 'rw', isa => 'bool');

1;
