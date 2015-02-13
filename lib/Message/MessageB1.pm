package Message::MessageB1;

use Moose;

extends 'Message';

use constant {
	ONE => 1,
	TWO => 2,
	THREE => 3,
};


has 'version' => (is => 'ro', isa => 'header_int', default => '1', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'type' =>    (is => 'ro', isa => 'header_int', default => '60', traits => ["DataType"], data_type => Types::PRIMITIVE);

has 'b_uint16_1' => (is => 'rw', isa => 'uint16', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'b_obj_sa1' => (is => 'rw', isa => 'Message::Standalone1', traits => ["DataType"], data_type => Types::OBJECT);
has 'b_obj_sa2_h' => (is => 'rw', isa => 'HashRef', traits => ["Mapped", "DataType"], key_types => ["uint32", "Message::Standalone2"], data_type => Types::MAP );
has 'b_uint16_2' => (is => 'rw', isa => 'uint16', traits => ["DataType"], data_type => Types::PRIMITIVE);

__PACKAGE__->meta->make_immutable();

1;
