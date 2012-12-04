#Load this file to require all traits.

Dir.foreach(File.dirname(__FILE__) + '/../traits') do |f|
  if f[0,1] == '.' || f[0,1] == '~'
    next
  end

  require File.dirname(__FILE__) + "/../traits/#{f[0..-4]}"
end
