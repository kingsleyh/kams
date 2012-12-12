require 'active_support/core_ext/string/inflections'
require File.dirname(__FILE__) + '/../util/emoticon'
require File.dirname(__FILE__) + '/../util/slant'
require File.dirname(__FILE__) + '/../objects/player'


#Communication commands.
module Communication
  class << self
    #Says something to the room or to a specific player.
    def say(event, player, room)
      phrase = event[:phrase]
      target = event[:target] && room.find(event[:target])
      prefix = event[:pre]

      if prefix
        prefix << ", "
      else
        prefix = ""
      end

      message = nil
      message = 'Huh?' if phrase.nil?
      message = 'Say what to whom?' if event[:target] and target.nil?
      message = 'Talking to yourself again?' if target and target == player
      return player.output(message) unless message.nil?

      phrase[0, 1] = phrase[0, 1].capitalize
      phrase.gsub!(/(\s|^|\W)(i)(\s|$|\W)/) { |match| match.sub('i', 'I') }

      emoticon = Emoticon.find_first_from(phrase)
      slant = Slant.find_first_from(phrase)

      player_voice = "say"
      room_voice = "says"

      if emoticon
        player_voice = "#{emoticon} and say"
        room_voice = "#{emoticon.pluralize} and says"
        if emoticon == "laugh"
          player_voice = "#{emoticon} as you say"
          room_voice = "#{emoticon.pluralize} as #{player.pronoun} says"
        end
      end

      if slant
        player_voice = "#{slant}"
        room_voice = "#{slant.pluralize}"
      end

      phrase = Emoticon.strip_from(phrase)
      phrase = Slant.apply_to(phrase, slant)
      phrase = "<say>\"#{phrase}\"</say>"

      event[:target] = target
      if target.nil?
        event[:to_player] = prefix + "you #{player_voice}, #{phrase}"
        event[:to_other] = prefix + "#{player.name} #{room_voice}, #{phrase}"
        event[:to_blind_other] = "Someone #{room_voice}, #{phrase}"
        event[:to_deaf_target] = "You see #{player.name} say something."
        event[:to_deaf_other] = "You see #{player.name} say something."
      end

      if !target.nil?
        if slant == "ask"
          event[:to_target] = prefix + "#{player.name} #{room_voice} you, #{phrase}"
          event[:to_player] = prefix + "you #{player_voice} #{target.name}, #{phrase}"
          event[:to_other] = prefix + "#{player.name} #{room_voice} #{target.name}, #{phrase}"
          event[:to_blind_target] = "Someone asks, #{phrase}"
          event[:to_blind_other] = "Someone asks, #{phrase}"
          event[:to_deaf_target] = "#{player.name} seems to be asking you something."
          event[:to_deaf_other] = "#{player.name} seems to be asking #{target.name} something."
        else
          event[:to_target] = prefix + "#{player.name} #{room_voice} to you, #{phrase}"
          event[:to_player] = prefix + "you #{player_voice} to #{target.name}, #{phrase}"
          event[:to_other] = prefix + "#{player.name} #{room_voice} to #{target.name}, #{phrase}"
          event[:to_blind_target] = "Someone #{room_voice}, #{phrase}"
          event[:to_blind_other] = "Someone #{room_voice}, #{phrase}"
          event[:to_deaf_target] = "You see #{player.name} say something to you."
          event[:to_deaf_other] = "You see #{player.name} say something to #{target.name}."
        end
      end
      room.out_event(event)
    end

    #Whispers to another thing.
    def whisper(event, player, room)
      object = room.find(event[:to], Player)

      if object.nil?
        player.output("To whom are you trying to whisper?")
        return
      elsif object == player
        player.output("Whispering to yourself again?")
        event[:to_other] = "#{player.name} whispers to #{player.pronoun(:reflexive)}."
        room.out_event(event, player)
        return
      end

      phrase = event[:phrase]

      if phrase.nil?
        player.output "What are you trying to whisper?"
        return
      end

      prefix = event[:pre]

      if prefix
        prefix << ", "
      else
        prefix = ""
      end

      phrase[0, 1] = phrase[0, 1].capitalize

      last_char = phrase[-1..-1]

      unless ["!", "?", "."].include? last_char
        ender = "."
      end

      phrase = ", <say>\"#{phrase}#{ender}\"</say>"

      event[:target] = object
      event[:to_player] = prefix + "you whisper to #{object.name}#{phrase}"
      event[:to_target] = prefix + "#{player.name} whispers to you#{phrase}"
      event[:to_other] = prefix + "#{player.name} whispers quietly into #{object.name}'s ear."
      event[:to_other_blind] = "#{player.name} whispers."
      event[:to_target_blind] = "Someone whispers to you#{phrase}"

      room.out_event(event)
    end

    #Tells someone something.
    def tell(event, player, room)
      target = $manager.find event[:target]
      unless target and target.is_a? Player
        player.output "That person is not available."
        return
      end

      if target == player
        player.output "Talking to yourself?"
        return
      end

      phrase = event[:message]

      last_char = phrase[-1..-1]

      unless ["!", "?", "."].include? last_char
        phrase << "."
      end

      phrase[0, 1] = phrase[0, 1].upcase
      phrase = phrase.strip.gsub(/\s{2,}/, ' ')

      player.output "You tell #{target.name}, <tell>\"#{phrase}\"</tell>"
      target.output "#{player.name} tells you, <tell>\"#{phrase}\"</tell>"
      target.reply_to = player.name
    end

    #Reply to a tell.
    def reply(event, player, room)
      unless player.reply_to
        player.output "There is no one to reply to."
        return
      end

      event[:target] = player.reply_to

      tell(event, player, room)
    end
  end
end

