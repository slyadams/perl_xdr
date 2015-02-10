package Message::Strings;

use Moose;

extends 'Message';

has 'version' => (is => 'ro', isa => 'header_int', default => '1');
has 'type' =>    (is => 'ro', isa => 'header_int', default => '2');

has 'string1' => (is => 'rw', isa => 'string');
has 'string2' => (is => 'rw', isa => 'string');
has 'string3' => (is => 'rw', isa => 'string');

__PACKAGE__->meta->make_immutable();

1;
