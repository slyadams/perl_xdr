package Traits::Mapped;

use Moose::Role;
Moose::Util::meta_attribute_alias('Mapped');

# Map traits which supports adding of key/value types
has key_types => (
    is        => 'rw',
    isa       => 'ArrayRef',
    predicate => 'is_map',
);

1;
