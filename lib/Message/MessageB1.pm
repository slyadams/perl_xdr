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

has 'b_uint16_1' => (is => 'rw', isa => 'uint16');
has 'b_obj_sa1' => (is => 'rw', isa => 'Message::Standalone1');
has 'b_obj_sa2_h' => (is => 'rw', isa => 'HashRef', traits => ["Mapped"], key_types => ["uint32", "Message::Standalone2"] );
has 'b_uint16_2' => (is => 'rw', isa => 'uint16');

__PACKAGE__->meta->make_immutable();

1;
