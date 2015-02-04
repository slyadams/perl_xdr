package Message::Standalone2;

use Moose;

extends 'Message';

has 'uint16_sb' => (is => 'rw', isa => 'uint16');
has 'uint16_sb2' => (is => 'rw', isa => 'uint16');

1;
