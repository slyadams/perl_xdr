use Moose::Util::TypeConstraints;

subtype 'int',
	as 'Int';

subtype 'int16',
	as 'int',
	where { $_ >= -(1 << 15) && $_ <= (2**15)-1 };

subtype 'int32',
	as 'int',
	where { $_ >= -(1 << 31) && $_ <= (2**31)-1 };

subtype 'int64',
	as 'int',
	where { $_ >= -(1 << 63) && $_ <= (2**63)-1 };

subtype 'uint',
	as 'Int',
	where { $_ >= 0 };

subtype 'uint16',
	as 'uint',
	where { $_ <= 2**16-1 };

subtype 'uint32',
	as 'uint',
	where { $_ <= 2**32-1  };

subtype 'uint64',
	as 'uint',
	where { $_ <= 2**64-1  };

subtype 'header_int',
	as 'uint16';

subtype 'float',
	as 'Num';

subtype 'double',
	as 'Num';

subtype 'bool',
	as 'uint',
	where { $_ <= 1  };

subtype 'string',
	as 'Str';

subtype 'bytes',
	as 'Value';


no Moose::Util::TypeConstraints;

1;
