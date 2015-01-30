package MooseTest::Test;

use Moose;
use MooseTest::Types;

has 'uint8' => (is => 'rw', isa => 'uint8');
has 'uint16' => (is => 'rw', isa => 'uint16');
has 'uint32' => (is => 'rw', isa => 'uint32');
has 'uint64' => (is => 'rw', isa => 'uint64');
has 'int8' => (is => 'rw', isa => 'int8');
has 'int16' => (is => 'rw', isa => 'int16');
has 'int32' => (is => 'rw', isa => 'int32');
has 'int64' => (is => 'rw', isa => 'int64');
has 'bool' => (is => 'rw', isa => 'bool');
has 'string' => (is => 'rw', isa => 'string');

1;
