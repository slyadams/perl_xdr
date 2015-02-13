package Message::Simple;

use Moose;
use Types;

extends 'Message';

has 'uint16' => (is => 'rw', isa => 'uint16', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'uint32' => (is => 'rw', isa => 'uint32', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'uint64' => (is => 'rw', isa => 'uint64', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'int16' => (is => 'rw', isa => 'int16', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'int32' => (is => 'rw', isa => 'int32', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'int64' => (is => 'rw', isa => 'int64', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'bool' => (is => 'rw', isa => 'bool', traits => ["DataType"], data_type => Types::PRIMITIVE);
has 'string' => (is => 'rw', isa => 'string', traits => ["DataType"], data_type => Types::PRIMITIVE);

 __PACKAGE__->meta->make_immutable();

1;
