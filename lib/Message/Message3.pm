package Message::Message3;

use Moose;

extends 'Message::Message2';

has 'bool' => (is => 'rw', isa => 'bool');

1;
