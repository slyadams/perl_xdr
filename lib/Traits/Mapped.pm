package Traits::Mapped;

use Moose::Role;
Moose::Util::meta_attribute_alias('Mapped');

has key_types => (
    is        => 'rw',
    isa       => 'ArrayRef',
    predicate => 'is_map',
);

1;
