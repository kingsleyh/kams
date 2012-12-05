require File.dirname(__FILE__) + '/commands'

class GenericCommands < Commands

  def self.has_this?(command)
    all_commands.include?(command)
  end

  def self.all_commands
    Set.new(%w(bug date delete look l get take feel idea taste smell sniff lick listen grab give health hunger satiety i inv inventory more quit open close shut drop put help lock unlock status stat st time typo who write))
  end

  def self.category
    :Generic
  end

  def delete_me_please
    condition(/^delete me please$/) do |with|
      {:action => :deleteme} unless with.nil?
    end
  end

  def look
    condition(/^(l|look)$/i) do |with|
      {:action => :look} unless with.nil?
    end
  end

  def look_in
    condition(/^(?<action>l|look)\s+(in|inside)\s+(?<in>.*)$/i) do |with|
      {:action => :look, :in => with[:in]} unless with.nil?
    end
  end

  def look_at
    condition(/^(l|look)\s+(?<at>.*)$/i) do |with|
      {:action => :look, :at => with[:at]} unless with.nil?
    end
  end

  def issue_create
    condition(/^(?<itype>bug|typo|idea)\s+(?<issue_id>\d+)\s+(?<option>show|del|add|status)(\s+(?<value>.+))?$/i) do |with|
      {:action => :issue, :itype => with[:itype].downcase.to_sym, :issue_id => with[:issue_id], :option => with[:option].downcase, :value => with[:value]} unless with.nil?
    end
  end

  def issue_show
    condition(/^(?<itype>bug|typo|idea)\s+(?<issue_id>\d+)/i) do |with|
      {:action => :issue, :itype => with[:itype].downcase.to_sym, :option => "show", :issue_id => with[:issue_id]} unless with.nil?
    end
  end

  def issue_create_reverse
    condition(/^(?<itype>bug|typo|idea)\s+(?<option>del|add|show|status)\s+(?<issue_id>\d+)(\s+(?<value>.+))?/i) do |with|
      {:action => :issue, :itype => with[:itype].downcase.to_sym, :option => with[:option].downcase, :issue_id => with[:issue_id], :value => with[:value]} unless with.nil?
    end
  end

  def issue_show_reverse
    condition(/^(?<itype>bug|typo|idea)\s+(?<option>new|show|del|add|status|list)(\s+(?<value>.+))?$/i) do |with|
      {:action => :issue, :itype => with[:itype].downcase.to_sym, :option => with[:option].downcase, :value => with[:value]} unless with.nil?
    end
  end

  def issue_create_simple
    condition(/^(?<itype>bug|typo|idea)\s+(?<value>.*)$/i) do |with|
      {:action => :issue, :itype => with[:itype].downcase.to_sym, :option => "new", :value => with[:value]} unless with.nil?
    end
  end

  def lock
    condition(/^lock\s+(?<object>.*)$/i) do |with|
      {:action => :lock, :object => with[:object]} unless with.nil?
    end
  end

  def unlock
    condition(/^unlock\s+(?<object>.*)$/i) do |with|
      {:action => :unlock, :object => with[:object]} unless with.nil?
    end
  end

  def get_from
    condition(/^(get|grab|take)\s+((?<object>\w+|\s)*)(\s+from\s+(?<from>\w+))/i) do |with|
      {:action => :get, :object => with[:object].strip, :from => with[:from]} unless with.nil?
    end
  end

  def get
    condition(/^(get|grab|take)\s+(?<object>.*)$/i) do |with|
      {:action => :get, :object => with[:object].strip} unless with.nil?
    end
  end

  def give
    condition(/^give\s+((?<item>\w+\s*)*)\s+to\s+(?<to>\w+)/i) do |with|
      {:action => :give, :item => with[:item].strip, :to => with[:to]} unless with.nil?
    end
  end

  def inventory
    condition(/^(i|inv|inventory)$/i) do |with|
      {:action => :show_inventory} unless with.nil?
    end
  end

  def more
    condition(/^more/i) do |with|
      {:action => :more} unless with.nil?
    end
  end

  def open
    condition(/^open\s+(?<object>\w+)$/i) do |with|
      {:action => :open, :object => with[:object]} unless with.nil?
    end
  end

  def close
    condition(/^(close|shut)\s+(?<object>\w+)$/i) do |with|
      {:action => :close, :object => with[:object]} unless with.nil?
    end
  end

  def drop
    condition(/^drop\s+((?<object>\w+\s*)*)$/i) do |with|
      {:action => :drop, :object => with[:object].strip} unless with.nil?
    end
  end

  def quit
    condition(/^quit$/i) do |with|
      {:action => :quit} unless with.nil?
    end
  end

  def put
    condition(/^put((\s+(?<count>\d+)\s+)|\s+)(?<item>\w+)\s+in\s+(?<container>\w+)$/i) do |with|
      {:action => :put, :item => with[:item], :count => with[:count].to_i, :container => with[:container]} unless with.nil?
    end
  end

  def help
    condition(/^help(?<object>.*)$/i) do |with|
      {:action => :help, :object => with[:object].strip} unless with.nil?
    end
  end

  def health
    condition(/^(health)$/i) do |with|
      {:action => :health} unless with.nil?
    end
  end

  def hunger
    condition(/^(satiety|hunger)$/i) do |with|
      {:action => :satiety} unless with.nil?
    end
  end

  def status
    condition(/^(st|stat|status)$/i) do |with|
      {:action => :status} unless with.nil?
    end
  end

  def write
    condition(/^write\s+(?<target>.*)/i) do |with|
      {:action => :write, :target => with[:target].strip} unless with.nil?
    end
  end

  def sense
    condition(/^(?<action>listen|sniff|smell|taste|lick|feel)(\s+(?<target>.+))?$/i) do |with|
      unless with.nil?
        action = with[:action].downcase.to_sym
        if with[:action].downcase == "sniff"
          action = :smell
        elsif with[:action].downcase == "lick"
          action = :taste
        end
        {:action => action, :target => with[:target]}
      end
    end
  end

  def who
    condition(/^who$/i) do |with|
      {:action => :who} unless with.nil?
    end
  end

  def time
    condition(/^time$/i) do |with|
      {:action => :time} unless with.nil?
    end
  end

  def date
    condition(/^date$/i) do |with|
      {:action => :date} unless with.nil?
    end
  end


end
