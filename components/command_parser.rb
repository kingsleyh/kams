require 'set'
require File.dirname(__FILE__) + '/../lib/event'
require File.dirname(__FILE__) + '/../lib/util'
require File.dirname(__FILE__) + '/../util/core_extentions'
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

  @mobile = Set.new(['teach'])

  #etc...

  class <<self

    #Creates an event to occur in the future. The event can be an event generated with CommandParser.parse or a block to be executed
    #when the time elapses.
    #
    #If a block is given, the event parameter is ignored.
    def future_event(player, seconds_delay, f_event = nil, &block)
      event = Event.new(:Future, :player => player, :time => seconds_delay)

      if block_given?
        event.action = :call
        event.event = block
      else
        event.action = :event
        event.event = f_event
      end

      event
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

    def parse_admin(input)
      event = Event.new(:Admin)

      case input
        when /^astatus/i
          event[:action] = :astatus
        when /^ahelp(.*)$/i
          event[:action] = :ahelp
          event[:object] = $1
        when /^awho/i
          event[:action] = :awho
        when /^(ac|acreate)\s+(\w+)\s*(.*)$/i
          event[:action] = :acreate
          event[:object] = $2
          event[:name] = $3.strip
        when /^acarea\s+(.*)$/i
          event[:action] = :acarea
          event[:name] = $1.strip
        when /^acroom\s+(\w+)\s+(.*)$/i
          event[:action] = :acroom
          event[:out_dir] = $1
          event[:in_dir] = opposite_dir($1)
          event[:name] = $2
        when /^acexit\s+(\w+)\s+(.*)$/i
          event[:action] = :acreate
          event[:object] = "exit"
          event[:alt_names] = [$1.strip]
          event[:args] = [$2.strip]
        when /^acdoor\s+(\w+)$/i
          event[:action] = :acdoor
          event[:direction] = $1
        when /^acdoor\s+(\w+)\s+(.*)$/i
          event[:action] = :acdoor
          event[:direction] = $1.strip
          event[:exit_room] = $2.strip
        when /^aconfig(\s+reload)?$/i
          event[:action] = :aconfig
          event[:setting] = "reload" if $1
        when /^aconfig\s+(\w+)\s+(.*)$/i
          event[:action] = :aconfig
          event[:setting] = $1
          event[:value] = $2
        when /^acportal(\s+(jump|climb|crawl|enter))?(\s+(.*))?$/i
          event[:action] = :acportal
          event[:object] = "portal"
          event[:alt_names] = []
          event[:portal_action] = $2
          event[:args] = [$4]
        when /^portal\s+(.*?)\s+(action|exit|entrance|portal)\s+(.*)$/i
          event[:action] = :portal
          event[:object] = $1
          event[:setting] = $2.downcase
          event[:value] = $3.strip
        when /^acprop\s+(.*)$/i
          event[:action] = :acreate
          event[:object] = "prop"
          event[:generic] = $1
        when /^adelete\s+(.*)$/i
          event[:action] = :adelete
          event[:object] = $1
        when /^deleteplayer\s+(\w+)$/i
          event[:action] = :delete_player
          event[:object] = $1.downcase
        when /^adesc\s+inroom\s+(.*?)\s+(.*)$/i
          event[:action] = :adesc
          event[:object] = $1
          event[:inroom] = true
          event[:desc] = $2
        when /^adesc\s+(.*?)\s+(.*)$/i
          event[:action] = :adesc
          event[:object] = $1
          event[:desc] = $2
        when /^ahide\s+(.*)$/i
          event[:action] = :ahide
          event[:object] = $1
          event[:hide] = true
        when /^ashow\s+(.*)$/i
          event[:action] = :ahide
          event[:object] = $1
          event[:hide] = false
        when /^ainfo\s+set\s+(.+)\s+@((\w|\.|\_)+)\s+(.*?)$/i
          event[:action] = :ainfo
          event[:command] = "set"
          event[:object] = $1
          event[:attrib] = $2
          event[:value] = $4
        when /^ainfo\s+(del|delete)\s+(.+)\s+@((\w|\.|\_)+)$/i
          event[:action] = :ainfo
          event[:command] = "delete"
          event[:object] = $2
          event[:attrib] = $3
        when /^ainfo\s+(show|clear)\s+(.*)$/i
          event[:action] = :ainfo
          event[:object] = $2
          event[:command] = $1
        when /^alook$/i
          event[:action] = :alook
        when /^alook\s+(.*)$/i
          event[:action] = :alook
          event[:at] = $1
        when /^alist$/i
          event[:action] = :alist
        when /^alist\s+(@\w+|class)\s+(.*)/i
          event[:action] = :alist
          event[:attrib] = $2
          event[:match] = $1
        when /^aset\s+(.+?)\s+(@\w+|smell|feel|texture|taste|sound|listen)\s+(.*)$/i
          event[:action] = :aset
          event[:object] = $1
          event[:attribute] = $2
          event[:value] = $3
        when /^aset!\s+(.+?)\s+(@\w+|smell|feel|texture|taste|sound|listen)\s+(.*)$/i
          event[:action] = :aset
          event[:object] = $1
          event[:attribute] = $2
          event[:value] = $3
          event[:force] = true
        when /^aput\s+(.*?)\s+in\s+(.*?)$/i
          event[:action] = :aput
          event[:object] = $1
          event[:in] = $2
        when /^areas$/i
          event[:action] = :areas
        when /^areload\s+(.*)$/i
          event[:action] = :areload
          event[:object] = $1
        when /^areact\s+load\s+(.*?)\s+(\w+)$/i
          event[:action] = :areaction
          event[:object] = $1
          event[:command] = "load"
          event[:file] = $2
        when /^areact\s+(add|delete)\s+(.*?)\s+(\w+)$/i
          event[:action] = :areaction
          event[:object] = $2
          event[:command] = $1
          event[:action_name] = $3
        when /^areact\s+(reload|clear|show)\s+(.*?)$/i
          event[:action] = :areaction
          event[:object] = $2
          event[:command] = $1
        when /^alog\s+(\w+)(\s+(\d+))?$/i
          event[:action] = :alog
          event[:command] = $1
          event[:value] = $3.downcase if $3
        when /^acopy\s+(.*)$/i
          event[:action] = :acopy
          event[:object] = $1
        when /^alearn\s+(\w+)$/i
          event[:action] = :alearn
          event[:skill] = $1
        when /^ateach\s+(\w+)\s+(\w+)$/i
          event[:action] = :ateach
          event[:target] = $1
          event[:skill] = $2
        when /^aforce\s+(.*?)\s+(.*)$/i
          event[:action] = :aforce
          event[:target] = $1
          event[:command] = $2
        when /^(acomm|acomment)\s+(.*?)\s+(.*)$/i
          event[:action] = :acomment
          event[:target] = $2
          event[:comment] = $3
        when /^awatch\s+((start|stop)\s+)?(.*)$/i
          event[:action] = :awatch
          event[:target] = $3.downcase if $3
          event[:command] = $2.downcase if $2
        when /^asave$/i
          event[:action] = :asave
        when /^restart$/i
          event[:action] = :restart
        when /^terrain\s+area\s+(.*)$/i
          event[:action] = :terrain
          event[:target] = "area"
          event[:value] = $1
        when /^terrain\s+(room|here)\s+(type|indoors|underwater|water)\s+(.*)$/
          event[:action] = :terrain
          event[:target] = "room"
          event[:setting] = $2.downcase
          event[:value] = $3
        when /^whereis\s(.*)$/
          event[:action] = :whereis
          event[:object] = $1
        else
          return nil
      end

      event
    end

  end
end
