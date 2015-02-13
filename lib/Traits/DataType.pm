package Traits::DataType;

use Moose::Role;
Moose::Util::meta_attribute_alias('DataType');

# Provides a way of encoding the type of the attribute, this would be detectable, but is faster to provide statically
has data_type => (
    is        => 'rw',
    isa       => 'uint32',
    predicate => 'is_data_type',
);

1;
