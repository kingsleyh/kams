require File.dirname(__FILE__) + '/commands'

class CommunicationCommands < Commands

  def self.has_this?(command)
    all_commands.include?(command)
  end

  def self.all_commands

  end

  def self.category
    :Custom
  end

end


#def parse_custom(input)
#  if input =~ /^(\w+)\s+(.*)$/
#    event = Event.new(:Custom)
#    event[:action] = :custom
#    event[:custom_action] = $1
#    event[:target] = $2
#    event
#  else
#    nil
#  end
#end