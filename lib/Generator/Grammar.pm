package Generator::Grammar;

use strict;

sub get_grammar {
	my $class = shift;
	return q {
		File: Package Definition(s?) { $return = { package => $item[1], definitions =>  $item[2] }}
		Package: 'package' /[^;]+ / ';' { $return = $item[2]; }
		Definition: Enum | Object | Import |  CommentString { $return = $item[1] }
		Object: 'object' ObjectName '{' ObjectLine(s?) /};?/ /;?/ { $return = { type => "object", name => $item[2], content => $item[4] } }
		ObjectName: /\w+/
		Import: 'import' Value /;?/ { $return = { import => $item[2] }; }
		Enum: 'enum' ObjectName '{' EnumLine(s?) /};?/ /;?/ { $return = { type => "enum", name => $item[2], content => $item[4] } }
		EnumLine: Name '=' Value Option(?)';' { $return = { name => $item{Name}, value => $item{Value} }}
		ObjectLine: OptionLine | RequiredLine | RepeatedLine | OptionalLine | Comment
		OptionLine: 'option' Name '=' Value ';' Comment(?) { $return = { type => 'option', name => $item{Name}, value => $item{Value}, data_type => "uint16", comment => $item[6] }}
		RequiredLine: 'required' Type Name '=' Value Option(?) ';' Comment(?) { $return = { type => 'required', data_type => $item{Type}, name => $item{Name}, value => $item{Value}, options => $item[6], comment => $item[8] } }
		RepeatedLine: 'repeated' Type Name '=' Value Option(?) ';' Comment(?) { $return = { type => 'required', data_type => $item{Type}, name => $item{Name}, value => $item{Value}, options => $item[6], repeated => 1, comment => $item[8] } }
		OptionalLine: 'optional' Type Name '=' Value Option(?) ';' Comment(?)  { $return = { type => 'required', data_type => $item{Type}, name => $item{Name}, value => $item{Value}, options => $item[6], optional => 1, comment => $item[8] } }

		Option: '[' Name '=' OptionValue ']' { $return = { option => $item[2], value => $item[4] } }
		Name: /\w+/
		Value: /\"?([\w\.]*)\"?/ { $return =  $1; }
		OptionValue: /([^]]*)/ { $return =  $1; }
		Type: /\w+/
		CommentString: Commentline(s) { $return =  { comment => (defined $item[1] ?  join("\n", @{$item[1]}) : undef )} }
		Comment: Commentline(s) { $return = (defined $item[1] ?  join("\n", @{$item[1]}) : undef ) }
		Commentline: /\/\/(.*)\n/ { $return = $1; }
	};
}

1;
