package Message::Defaults;

use Moose;

extends 'Message';

has 'version' => (is => 'ro', isa => 'header_int', default => '1');
has 'type' =>    (is => 'ro', isa => 'header_int', default => '80');

has 'uint16' => (is => 'rw', isa => 'uint16');
has 'uint32' => (is => 'rw', isa => 'uint32');
has 'uint64' => (is => 'rw', isa => 'uint64');
has 'int16' => (is => 'rw', isa => 'int16');
has 'int32' => (is => 'rw', isa => 'int32');
has 'int64' => (is => 'rw', isa => 'int64');
has 'float' => (is => 'rw', isa => 'float');
has 'double' => (is => 'rw', isa => 'double');
has 'bool' => (is => 'rw', isa => 'bool');
has 'string' => (is => 'rw', isa => 'string');



__PACKAGE__->meta->make_immutable();

1;
