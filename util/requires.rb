class Requires

  def self.one_level_nested(path)
    rejections = ['.', '..']
    Dir.entries(path).reject { |d| rejections.include?(d) }.each do |file|
      file = "#{path}/#{file}"
      if File.directory?(file)
        Dir.entries(file).reject { |d| rejections.include?(d) }.each do |sub|
          sub = "#{file}/#{sub}"
          require sub
        end
      else
        require file
      end
    end
  end

end