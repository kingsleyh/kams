require File.dirname(__FILE__) + '/commands'

class SettingsCommands < Commands

  def self.has_this?(command)
    all_commands.include?(command)
  end

  def self.all_commands
    Set.new(%w(set))
  end

  def self.category
    :Settings
  end

  def enable_colours
    condition(/^set\s+colors?\s+(?<option>on|off|default)$/i) do |with|
      {:action => :setcolor, :option => with[:option]} unless with.nil?
    end
  end

  def set_colours
    condition(/^set\s+colors?\s+(?<option>\w+)\s+(?<color>\w+)$/i) do |with|
      {:action => :setcolor, :option => with[:option], :color => with[:color]} unless with.nil?
    end
  end

  def show_colours
    condition(/^set\s+colors?.*/i) do |with|
      {:action => :showcolors} unless with.nil?
    end
  end

  def set_password
    condition(/^set\s+password$/i) do |with|
      {:action => :setpassword} unless with.nil?
    end
  end

  def set
    condition(/^set\s+(?<setting>\w+)\s*(?<value>.*)$/i) do |with|
      {:action => :set, :setting => with[:setting].strip, :value => with[:value].andand.strip} unless with.nil?
      end
  end

end
