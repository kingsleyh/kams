require 'set'
require 'active_support/core_ext/object/blank'
require File.dirname(__FILE__) + '/../lib/event'
require File.dirname(__FILE__) + '/../lib/util'
require File.dirname(__FILE__) + '/commands/generic_commands'
require File.dirname(__FILE__) + '/commands/communication_commands'
require File.dirname(__FILE__) + '/commands/movement_commands'
require File.dirname(__FILE__) + '/commands/emotes_commands'
require File.dirname(__FILE__) + '/commands/equipment_commands'
require File.dirname(__FILE__) + '/commands/settings_commands'
require File.dirname(__FILE__) + '/commands/weaponcombat_commands'
require File.dirname(__FILE__) + '/commands/martialcombat_commands'
require File.dirname(__FILE__) + '/commands/news_commands'
require File.dirname(__FILE__) + '/commands/custom_commands'
require File.dirname(__FILE__) + '/commands/admin_commands'
require File.dirname(__FILE__) + '/commands/event_commands'
require 'andand'

#CommandParser parses commands into commands for the event handler.
module CommandParser

  class <<self

    #Creates an event to occur in the future. The event can be an event generated with CommandParser.parse or a block to be executed
    #when the time elapses.
    #
    #If a block is given, the event parameter is ignored.
    def future_event(player, second_delay, f_event = nil, &block)
      arguments = block_given? ? {:action => :call, :event => block} : {:action => :event, :event => f_event}
      Event.new(:Future, arguments.merge(:player => player,:time => second_delay))
    end


    def parse(player, input)
      command = input.split.first.andand.downcase
      return nil if command.blank?
      event = nil
      event = create_command_event_for(input, GenericCommands) if GenericCommands.has_this?(command)
      event = create_command_event_for(input, CommunicationCommands) if CommunicationCommands.has_this?(command)
      event = create_command_event_for(input, MovementCommands) if MovementCommands.has_this?(command)
      event = create_command_event_for(input, EmotesCommands) if EmotesCommands.has_this?(command)
      event = create_command_event_for(input, EquipmentCommands) if EquipmentCommands.has_this?(command)
      event = create_command_event_for(input, SettingsCommands) if SettingsCommands.has_this?(command)
      event = create_command_event_for(input, WeaponcombatCommands) if WeaponcombatCommands.has_this?(command)
      event = create_command_event_for(input, MartialcombatCommands) if MartialcombatCommands.has_this?(command)
      event = create_command_event_for(input, NewsCommands) if NewsCommands.has_this?(command)
      event = create_command_event_for(input, AdminCommands) if AdminCommands.has_this?(command) and player.admin
      event = create_event_for(input, player, EventCommands) if EventCommands.has_this?(command)
      event = create_command_event_for(input, CustomCommands) if event.nil?
      event.player = player unless event.nil?
      event
    end
    alias :create_event :parse

    private
    def create_command_event_for(input, command_klass)
      command_class = command_klass.new(input)
      command = nil
      command_klass.instance_methods(false).to_set.each do |method|
        command = command_class.send(method)
        break unless command.nil?
      end
      Event.new(command_klass.category, command) if command
    end

    def create_event_for(input, player, command_klass)
      event = nil
      command_class = command_klass.new(input, player)
      command_klass.instance_methods(false).to_set.each do |method|
        event = command_class.send(method)
        break unless event.nil?
      end
      event
    end

  end
end
