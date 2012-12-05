require File.dirname(__FILE__) + '/commands'

class WeaponcombatCommands < Commands

  def self.has_this?(command)
    all_commands.include?(command)
  end

  def self.all_commands
    Set.new(%w(wield unwield slash block))
  end

  def self.category
    :WeaponCombat
  end

  def wield
    condition(/^wield\s+(?<weapon>.*?)(\s+(?<side>\w+))?$/i) do |with|
      {:action => :wield, :weapon => with[:weapon], :side => with[:side]} unless with.nil?
    end
  end

  def unwield
    condition(/^unwield(\s+(?<weapon>.*))?$/i) do |with|
      {:action => :unwield, :weapon => with[:weapon]} unless with.nil? unless with.nil?
    end
  end

  def slash
    condition(/^slash$/i) do |with|
      {:action => :slash} unless with.nil?
    end
  end

  def slash_target
    condition(/^slash\s+(?<target>.*)$/i) do |with|
      {:action => :slash, :target => with[:target]} unless with.nil?
    end
  end

  def block
    condition(/^block(\s+(?<target>.*))?$/i) do |with|
      {:action => :simple_block, :target => with[:target]} unless with.nil?
    end
  end

end
