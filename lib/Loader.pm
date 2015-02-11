package Loader;

use strict;
use warnings;
use Module::Pluggable search_path => [ "Message" ], instantiate => 'new';

sub new {
	my $class = shift;
	my $self = {};
	return bless($self, $class);
}

# Instantiate plugin
sub loadPlugin {
	my $class = shift;
	my $pluginName = shift;
	Class::Load::load_class($pluginName);
	return $pluginName->new();
}

# Load plugins from a directory
sub loadPlugins {
	my $self = shift;

	my @plugin_objs = $self->plugins();
	my $plugins = {};
	foreach my $plugin (@plugin_objs) {
		# All plugins go into the lookup for decoding sub messages
		$plugins->{name}->{ref($plugin)} = $plugin;

		# Only messages with types can be top level decoded based on 'type'
		if ($plugin->can('type')) {
			my $type = $plugin->type();
			if (defined $type) {
				$plugins->{id}->{$plugin->type()} = $plugin;
			} else {
				print STDERR "Cannot find type for object '".ref($plugin)."', this object is being discarded\n";
			}
		}
	}
	return $plugins;
}

1;
