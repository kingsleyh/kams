require File.dirname(__FILE__) + '/commands'

class EquipmentCommands < Commands

  def self.has_this?(command)
    all_commands.include?(command)
  end

  def self.all_commands
    Set.new(%w(wear remove))
  end

  def self.category
    :Clothing
  end

  def wear
    condition(/^wear\s+(?<object>\w+)(\s+on\s+(?<position>.*))?$/i) do |with|
      {:action => :wear, :object => with[:object], :position => with[:position]} unless with.nil?
    end
  end

  def remove
    condition(/^remove\s+(?<object>\w+)(\s+from\s+(?<position>.*))?$/i) do |with|
      {:action => :remove, :object => with[:object], :position => with[:position]} unless with.nil?
    end
  end

end