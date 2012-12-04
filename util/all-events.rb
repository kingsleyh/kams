#Load this file to require all event modules.

Dir.foreach(File.dirname(__FILE__) + '/../events') do |f|
  if f[0,1] == '.' || f[0,1] == '~'
    next
  end

  require File.dirname(__FILE__) + "/../events/#{f[0..-4]}"
end
