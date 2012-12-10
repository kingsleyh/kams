require 'active_support/core_ext/string/inflections'
require File.dirname(__FILE__) + '/../../util/expectancy'
require File.dirname(__FILE__) + '/../../util/emoticon'
require File.dirname(__FILE__) + '/../../util/slant'
require 'andand'

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
      phrasing = "say"
      phrasing = emoticon unless emoticon.nil?
      phrasing = "laughs as #{player.pronoun}" if emoticon == "laugh"
      phrasing = slant unless slant.nil?

      phrase = Emoticon.strip_from(phrase)
      phrase = Slant.apply_to(phrase,slant)

      #phrase = phrase.gsub(/\s*(:\)|:\()|:D/, '').strip.gsub(/\s{2,}/, ' ')


      phrase = "<say>\"#{phrase}\"</say>"


      Expectancy.when(target.nil?) do
        event[:to_player] = prefix + "you #{phrasing}, #{phrase}"
        event[:to_other] = prefix + "#{player.name} #{phrasing.pluralize}, #{phrase}"
        event[:to_blind_other] = "Someone #{phrasing.pluralize}, #{phrase}"
        event[:to_deaf_target] = "You see #{player.name} say something."
        event[:to_deaf_other] = "You see #{player.name} say something."
      end

      Expectancy.when(!target.nil?) do

        if emoticon == "ask"
          event[:to_target] = prefix + "#{player.name} #{phrasing.pluralize} you, #{phrase}"
          event[:to_player] = prefix + "you #{phrasing} #{target.name}, #{phrase}"
          event[:to_other] = prefix + "#{player.name} #{phrasing.pluralize} #{target.name}, #{phrase}"
          event[:to_blind_target] = "Someone asks, #{phrase}"
          event[:to_blind_other] = "Someone asks, #{phrase}"
          event[:to_deaf_target] = "#{player.name} seems to be asking you something."
          event[:to_deaf_other] = "#{player.name} seems to be asking #{target.name} something."
        else
          event[:to_target] = prefix + "#{player.name} #{phrasing.pluralize} to you, #{phrase}"
          event[:to_player] = prefix + "you #{phrasing} to #{target.name}, #{phrase}"
          event[:to_other] = prefix + "#{player.name} #{phrasing} to #{target.name}, #{phrase}"
          event[:to_blind_target] = "Someone #{phrasing.pluralize}, #{phrase}"
          event[:to_blind_other] = "Someone #{phrasing.pluralize}, #{phrase}"
          event[:to_deaf_target] = "You see #{player.name} say something to you."
          event[:to_deaf_other] = "You see #{player.name} say something to #{target.name}."
        end


      end

      #event[:target] = target
      #if target and pvoice == "ask"
      #  event[:to_target] = prefix + "#{player.name} #{rvoice} you, #{phrase}"
      #  event[:to_player] = prefix + "you #{pvoice} #{target.name}, #{phrase}"
      #  event[:to_other] = prefix + "#{player.name} #{rvoice} #{target.name}, #{phrase}"
      #  event[:to_blind_target] = "Someone asks, #{phrase}"
      #  event[:to_blind_other] = "Someone asks, #{phrase}"
      #  event[:to_deaf_target] = "#{player.name} seems to be asking you something."
      #  event[:to_deaf_other] = "#{player.name} seems to be asking #{target.name} something."
      #elsif target
      #  event[:to_target] = prefix + "#{player.name} #{rvoice} to you, #{phrase}"
      #  event[:to_player] = prefix + "you #{pvoice} to #{target.name}, #{phrase}"
      #  event[:to_other] = prefix + "#{player.name} #{rvoice} to #{target.name}, #{phrase}"
      #  event[:to_blind_target] = "Someone #{rvoice}, #{phrase}"
      #  event[:to_blind_other] = "Someone #{rvoice}, #{phrase}"
      #  event[:to_deaf_target] = "You see #{player.name} say something to you."
      #  event[:to_deaf_other] = "You see #{player.name} say something to #{target.name}."
      #else
      #  event[:to_player] = prefix + "you #{pvoice}, #{phrase}"
      #  event[:to_other] = prefix + "#{player.name} #{rvoice}, #{phrase}"
      #  event[:to_blind_other] = "Someone #{rvoice}, #{phrase}"
      #  event[:to_deaf_target] = "You see #{player.name} say something."
      #  event[:to_deaf_other] = "You see #{player.name} say something."
      #end

      room.out_event(event)
    end


  end
end