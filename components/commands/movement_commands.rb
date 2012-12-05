require File.dirname(__FILE__) + '/commands'

class MovementCommands < Commands

  def self.has_this?(command)
    all_commands.include?(command)
  end

  def self.all_commands
    Set.new(%w(go east e west w south s north n up u down d northeast ne northwest nw southeast se southwest sw in out sit stand pose enter climb jump crawl gait))
  end

  def self.category
    :Movement
  end

  def gait
    condition(/^gait(\s+(?<phrase>.*))?$/i) do |with|
      {:action => :gait, :phrase => with[:phrase]} unless with.nil?
    end
  end

  def go
    condition(/^go\s+(?<direction>.*)$/i) do |with|
      {:action => :move, :direction => with[:direction].downcase} unless with.nil?
    end
  end

  def enter
    condition(/^(?<portal_action>jump|climb|crawl|enter)\s+(?<object>.*)$/i) do |with|
      {:action => :enter, :portal_action => with[:portal_action].downcase, :object => with[:object]} unless with.nil?
    end
  end

  def sit_on
    condition(/^sit\s+on\s+(?<object>.*)$/i) do |with|
      {:action => :sit, :object => with[:object].strip} unless with.nil?
    end
  end

  def sit_target
    condition(/^sit\s+(?<object>.*)$/i) do |with|
      {:action => :sit, :object => with[:object]} unless with.nil?
    end
  end

  def sit
    condition(/^sit$/i) do |with|
      {:action => :sit} unless with.nil?
    end
  end

  def pose
    condition(/^pose\s+(?<pose>.*)$/i) do |with|
      {:action => :pose, :pose => with[:pose].strip} unless with.nil?
    end
  end

  def stand
    condition(/^stand$/i) do |with|
      {:action => :stand} unless with.nil?
    end
  end

  def move
    condition(/^(?<direction>east|west|northeast|northwest|north|southeast|southwest|south|e|w|nw|ne|sw|se|n|s|up|down|u|d|in|out)(\s+\((?<pre>.*)\))?$/i) do |with|
      {:action => :move, :direction => MovementCommands.expand_direction(with[:direction]), :pre => with[:pre]} unless with.nil?
    end
  end

  #def jump_portal
  #  condition(/^(jump|crawl|climb|enter)$/i) do |with|
  #    nil
  #  end
  #end

  def self.expand_direction dir
    return dir unless dir.is_a? String
    case dir.downcase
      when "e", "east"
        "east"
      when "w", "west"
        "west"
      when "n", "north"
        "north"
      when "s", "south"
        "south"
      when "ne", "northeast"
        "northeast"
      when "se", "southeast"
        "southeast"
      when "sw", "southwest"
        "southwest"
      when "nw", "northwest"
        "northwest"
      when "u", "up"
        "up"
      when "d", "down"
        "down"
      when "i", "in"
        "in"
      when "o", "out"
        "out"
      else
        dir
    end
  end

end