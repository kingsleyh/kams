#Load this file to require all event modules.
require File.dirname(__FILE__) + '/requires'
Requires.one_level_nested(File.expand_path(File.dirname(__FILE__) + '/../events'))
