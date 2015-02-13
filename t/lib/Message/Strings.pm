package Message::Strings;

use Moose;
use Types;

extends 'Message';

has 'version' => (is => 'ro', isa => 'header_int', default => '1', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'type' =>    (is => 'ro', isa => 'header_int', default => '2', traits => ["DataType"], data_type => Types::PRIMITIVE);

has 'string1' => (is => 'rw', isa => 'string', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'string2' => (is => 'rw', isa => 'string', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'string3' => (is => 'rw', isa => 'string', traits => ["DataType"], data_type => Types::PRIMITIVE);

__PACKAGE__->meta->make_immutable();

1;
