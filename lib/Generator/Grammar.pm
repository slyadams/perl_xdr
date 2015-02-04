package Generator::Grammar;

use strict;
use Data::Dumper;

sub get_grammar {
	my $class = shift;
	#File: Commentline(s?) Package Definition(s?) { $return = { package => $item[1], definitions =>  $item[2] }}
	return q {
		File: CommentMultiLine(s?) Package Definition(s?) {
			$return = { package => $item{Package}, definitions =>  [@{$item[1] || {}}, @{$item[3]}]};
		}
		Package: 'package' /[^;]+ / ';' {
			$return = $item[2];
		}
		Definition: Enum | Object | Import |  CommentMultiLine {
			$return = $item[1];
		}
		Object: 'object' ObjectName '{' Commentline(?) ObjectLine(s?) /};?/ /;?/ {
			$return = { type => "object", name => $item[2], comment => $item[4], content => $item[5] };
		}
		ObjectName: /\w+/
		Import: 'import' Value /;?/ {
			$return = { import => $item[2] };
		}
		Enum: 'enum' ObjectName '{' Commentline(?) EnumLine(s?) /};?/ /;?/ {
			$return = { type => "enum", name => $item[2], comment => $item[4], content => $item[5] };
		}
		EnumLine: Name '=' Value Option(?)';' Commentline(?) {
			$return = { name => $item{Name}, value => $item{Value}, comment => (exists $item[6][0] ? $item[6][0] : "") };
		}
		ObjectLine: OptionLine | RequiredLine | RepeatedLine | OptionalLine | Comment
		OptionLine: 'option' Name '=' Value ';' Comment(?) {
			$return = { type => 'option', name => $item{Name}, value => $item{Value}, data_type => "uint16", comment => (exists $item[6][0] ? $item[6][0] : "") };
		}
		RequiredLine: 'required' Type Name '=' Value Option(?) ';' Comment(?) {
			$return = { type => 'required', data_type => $item{Type}, name => $item{Name}, value => $item{Value}, options => $item[6], comment => (exists $item[8][0] ? $item[8][0] : "") };
		}
		RepeatedLine: 'repeated' Type Name '=' Value Option(?) ';' Comment(?) {
			$return = { type => 'required', data_type => $item{Type}, name => $item{Name}, value => $item{Value}, options => $item[6], repeated => 1, comment => (exists $item[8][0] ? $item[8][0] : "") };
		}
		OptionalLine: 'optional' Type Name '=' Value Option(?) ';' Comment(?)  {
			$return = { type => 'required', data_type => $item{Type}, name => $item{Name}, value => $item{Value}, options => $item[6], optional => 1, comment => $item[8] }
		}
		Option: '[' Name '=' OptionValue ']' {
			$return = { option => $item[2], value => $item[4] }
		}
		Name: /\w+/
		Value: /\"?([\w\.]*)\"?/ {
			$return =  $1;
		}
		OptionValue: /([^]]*)/ {
			$return =  $1;
		}
		Type: /\w+/
		CommentMultiLine: Commentline(s) {
			$return =  { type => "comment", comment => $item[1]};
		}
		Comment: Commentline(s) {
			$return = (defined $item[1] ?  join("\n", @{$item[1]}) : undef );
		}
		Commentline: /\/\/\s*(.*)\n/ {
			$return = $1;
		}
	};
}
#$return =  { type => "comment", comment => (defined $item[1] ?  join("\n", @{$item[1]}) : undef )};

1;
