package Message::Standalone2;

use Moose;

extends 'Message';

has 'uint16_sb' => (is => 'rw', isa => 'uint16');

1;
