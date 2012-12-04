#Load this file to require all objects.

Dir.glob(File.dirname(__FILE__) + '/../objects/*.rb').each do |f|
  require f[0..-4] unless  f[0,1] == '~'
end
