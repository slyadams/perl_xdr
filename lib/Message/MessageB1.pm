package Message::MessageB1;

use Moose;

extends 'Message';

use constant {
	ONE => 1,
	TWO => 2,
	THREE => 3,
};


has 'version' => (is => 'ro', isa => 'header_int', default => '1');
has 'type' =>    (is => 'ro', isa => 'header_int', default => '5001');

has 'uint16_a' => (is => 'rw', isa => 'uint16');
has 'obj1' => (is => 'rw', isa => 'Message::Standalone1');
has 'uint16_b' => (is => 'rw', isa => 'uint16');

1;
