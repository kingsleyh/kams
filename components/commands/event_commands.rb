require File.dirname(__FILE__) + '/commands'
require File.dirname(__FILE__) + '/../../lib/util'

class EventCommands < Commands

  def initialize(user_input, player)
    @user_input = user_input
    @player = player
  end

  def self.has_this?(command)
    all_commands.include?(command)
  end

  def self.all_commands
    Set.new(%w(alarm))
  end

  def alarm
    condition(/^alarm\s+(?<is_triggered>[0-9]+)$/i) do |alarm|
      unless alarm.nil?
        after alarm[:is_triggered].to_i do
          @player.output "***ALARM***"
        end
      end
    end
  end

  def alarm_with_message
        condition(/^alarm\s+(?<is_triggered>[0-9]+)\s+(?<unit>sec|min|hour|day|month)\s+(?<message>.+)$/i) do |alarm|
          unless alarm.nil?
            after alarm[:is_triggered].to_i, alarm[:unit].to_sym do
              @player.output "***ALARM*** : #{alarm[:message].strip}"
            end
          end
        end
    end
end
