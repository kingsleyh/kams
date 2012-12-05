require File.dirname(__FILE__) + '/commands'

class EmotesCommands < Commands

  def self.has_this?(command)
    all_commands.include?(command)
  end

  def self.all_commands
    Set.new(%w(smile cheer back laugh cry emote eh er eh? uh pet hug blush ew frown grin hm snicker wave poke yes no huh hi bye yawn bow curtsey brb agree sigh ponder shrug skip nod))
  end

  def self.category
    :Emote
  end

  def emote
    condition(/^emote\s+(?<show>.*)/i) do |with|
      {:action => :emote, :show => with[:show]} unless with.nil?
    end
  end

  def emote_predefined
    condition(/^(?<action>uh|er|eh\?|eh|shrug|sigh|ponder|agree|cry|hug|pet|smile|laugh|ew|blush|grin|frown|snicker|wave|poke|yes|no|huh|hi|bye|yawn|bow|curtsey|brb|skip|nod|back|cheer|hm)(\s+(?<object>[^()]*))?(\s+\((?<post>.*)\))?$/i) do |with|
      {:action => with[:action].downcase.to_sym, :object => with[:object], :post => with[:post]} unless with.nil?
      end
  end

end