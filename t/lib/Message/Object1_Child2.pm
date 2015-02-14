package Message::Object1_Child2;

use Moose;
use Types;

extends 'Message';

has 'uint32' => (is => 'rw', isa => 'uint32', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'bool' => (is => 'rw', isa => 'bool', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'string' => (is => 'rw', isa => 'string', traits => ["DataType"], data_type => Types::PRIMITIVE);

__PACKAGE__->meta->make_immutable();

1;
