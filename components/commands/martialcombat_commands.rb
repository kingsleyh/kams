require File.dirname(__FILE__) + '/commands'

class MartialcombatCommands < Commands

  def self.has_this?(command)
    all_commands.include?(command)
  end

  def self.all_commands
    Set.new(%w(punch kick dodge))
  end

  def self.category
    :MartialCombat
  end

  def punch
    condition(/^punch$/i) do |with|
      {:action => :punch} unless with.nil?
    end
  end

  def punch_target
    condition(/^punch\s+(?<target>.*)$/i) do |with|
      {:action => :punch, :target => with[:target]} unless with.nil?
    end
  end

  def kick
    condition(/^kick$/i) do |with|
      {:action => :kick} unless with.nil?
    end
  end

  def kick_target
    condition(/^kick\s+(?<target>.*)$/i) do |with|
      {:action => :kick, :target => with[:target]} unless with.nil?
    end
  end

  def dodge
    condition(/^dodge(\s+(?<target>.*))?$/i) do |with|
      {:action => :simple_dodge, :target => with[:target]} unless with.nil?
    end
  end

end