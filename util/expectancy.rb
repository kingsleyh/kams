class Expectancy

  def self.when(condition, &block)
    if block_given?
      block.call if condition
    end
  end

end
