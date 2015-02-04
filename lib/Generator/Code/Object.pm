package Generator::Code::Object;

use strict;
use warnings;

use base 'Generator::Code';

sub generate_package_name {
	my $class = shift;
	my $namespace = shift;
	my $package = shift;
	return "$namespace\_$package->{name}";
}



sub generate_package {
	my $class = shift;
	my $package_name = shift;
	my $namespace = shift;
	my $def = shift;
	my $comment = shift;

	my $comment_string = "";
	foreach my $comment (@{$comment}) {
		$comment_string .= "// $comment\n";
	}

	my $full_package_name = $class->generate_package_name($namespace, $def);

	return qq {package $namespace\:\:$full_package_name;

$comment_string
use strict;
use warnings;

use Moose;

extends 'Message';

};
}

sub generate {
	my $class = shift;
	my $object = shift;

	my $field_string = ""; 
	foreach my $field (@{$object->{content}}) {
                $field_string .= length($field->{comment}) > 0 ? "// $field->{comment}\n" : "";
		$field_string .= "has '$field->{name}' => (is => 'ro', isa => '$field->{data_type}',";
		if ($field->{type} eq "option") {
			$field_string .= " default => '$field->{value},";
		} elsif ($field->{type} eq "required") {
			
		}
		chop($field_string);
		$field_string .= ");\n";
	}
	$field_string .= "\n".$class->generate_footer();
	return $field_string;
}

1;
