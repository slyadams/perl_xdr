package Loader;

use strict;
use warnings;

sub loadPlugin {
	my $class = shift;
	my $pluginName = shift;
	my $plugin = undef;
	eval qq^
		use $pluginName;
		\$plugin = new $pluginName();
	^;
	return $plugin;
}

# Convert a filename into a Perl module name
sub _getPluginName {
	my $class = shift;
	my $fileName = shift;
	my $pluginName = $fileName;
	if ($pluginName =~ m/Message\/+(.*).pm/i) {
		return "Message::$1";
	} else {
		return undef;
	}
}

# Load plugins from a directory
sub loadPlugins {
	my $class = shift;
	my $directory = shift;
	
	if (-d $directory) {
		my $plugins;
		# Instantiate each module and push into return array
		foreach my $pluginFileName ( <$directory/*.pm> ) {
			my $pluginName = $class->_getPluginName($pluginFileName);
			my $plugin = $class->loadPlugin($pluginName);
			if (defined $plugin) {
				$plugins->{$plugin->type()} = $plugin;
			}
		}
		return $plugins;
	}
}

1;
