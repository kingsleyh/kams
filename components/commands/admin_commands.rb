require File.dirname(__FILE__) + '/commands'

class AdminCommands < Commands

  def self.has_this?(command)
    all_commands.include?(command)
  end

  def self.all_commands
    Set.new(%w(acreate alook adesc acarea acopy acomment acomm aconfig acportal ahelp portal aset aset! adelete aforce ahide ashow ainfo aput alist alearn areas ateach areload areact awho alog astatus acroom acexit acdoor acprop asave awatch deleteplayer restart terrain whereis))
  end

  def self.category
    :Admin
  end

  def astatus
    condition(/^astatus/i) do |with|
      {:action => :astatus} unless with.nil?
    end
  end

  def ahelp
    condition(/^ahelp(?<object>.*)$/i) do |with|
      {:action => :ahelp, :object => with[:object]} unless with.nil?
    end
  end

  def awho
    condition(/^awho/i) do |with|
      {:action => :awho} unless with.nil?
    end
  end

  def acreate
    condition(/^(ac|acreate)\s+(?<object>\w+)\s*(?<name>.*)$/i) do |with|
      {:action => :acreate, :object => with[:object], :name => with[:name].strip} unless with.nil?
    end
  end

  def acarea
    condition(/^acarea\s+(?<name>.*)$/i) do |with|
      {:action => :acarea, :name => with[:name]} unless with.nil?
    end
  end

  def acroom
    condition(/^acroom\s+(?<out_dir>\w+)\s+(?<name>.*)$/i) do |with|
      {:action => :acroom, :out_dir => with[:out_dir], :in_dir =>  opposite_dir(with[:out_dir]), :name => with[:name]} unless with.nil?
    end
  end

  def acexit
    condition(/^acexit\s+(?<alt_names>\w+)\s+(?<args>.*)$/i) do |with|
      {:action => :acreate, :object => 'exit', :alt_names => [with[:alt_names].strip], :args => [with[:args].strip]} unless with.nil?
    end
  end

  def acdoor
    condition(/^acdoor\s+(?<direction>\w+)$/i) do |with|
      {:action => :acdoor, :direction => with[:direction]} unless with.nil?
    end
  end

  def acdoor_exit
    condition(/^acdoor\s+(?<direction>\w+)\s+(?<exit_room>.*)$/i) do |with|
      {:action => :acdoor, :direction => with[:direction], :exit_room => with[:exit_room]} unless with.nil?
    end
  end

  def aconfig_reload
    condition(/^aconfig(\s+reload)?$/i) do |with|
      {:action => :aconfig, :setting => 'reload'} unless with.nil?
    end
  end

  def aconfig
    condition(/^aconfig\s+(?<setting>\w+)\s+(?<value>.*)$/i) do |with|
      {:action => :aconfig, :setting => with[:setting], :value => with[:value]} unless with.nil?
    end
  end

  def acportal
    condition(/^acportal(\s+(jump|climb|crawl|enter))?(?<portal_action>\s+(?<args>.*))?$/i) do |with|
      {:action => :acportal, :object => 'portal', :alt_names => [], :portal_action => with[:portal_action], :args => [with[:args]]} unless with.nil?
    end
  end

  def portal
    condition(/^portal\s+(?<object>.*?)\s+(?<setting>action|exit|entrance|portal)\s+(?<value>.*)$/i) do |with|
      {:action => :portal, :object => with[:object], :setting => with[:setting].downcase, :value => with[:value].strip} unless with.nil?
    end
  end

  def acprop
    condition(/^acprop\s+(?<generic>.*)$/i) do |with|
      {:action => :acreate, :object => 'prop', :generic => with[:generic]} unless with.nil?
    end
  end

  def adelete
    condition(/^adelete\s+(?<object>.*)$/i) do |with|
      {:action => :adelete, :object => with[:object]} unless with.nil?
    end
  end

  def delete_player
    condition(/^deleteplayer\s+(?<object>\w+)$/i) do |with|
      {:action => :delete_player, :object => with[:object]} unless with.nil?
    end
  end

  def adesc
    condition(/^adesc\s+inroom\s+(?<object>.*?)\s+(?<desc>.*)$/i) do |with|
      {:action => :adesc, :object => with[:object], :inroom => true, :desc => with[:desc]} unless with.nil?
    end
  end

  def adesc_plain
    condition(/^adesc\s+(?<object>.*?)\s+(?<desc>.*)$/i) do |with|
      {:action => :adesc, :object => with[:object], :desc => with[:desc]} unless with.nil?
    end
  end

  def ahide
    condition(/^ahide\s+(?<object>.*)$/i) do |with|
      {:action => :ahide, :object => with[:object], :hide => true} unless with.nil?
    end
  end

  def ashow
    condition(/^ashow\s+(.*)$/i) do |with|
      {:action => :ahide, :object => with[:object], :hide => false} unless with.nil?
    end
  end

  def ainfo_set
    condition(/^ainfo\s+set\s+(?<object>.+)\s+@((?<attrib>\w|\.|\_)+)\s+(?<value>.*?)$/i) do |with|
      {:action => :ainfo, :command => :set, :object => with[:object], :attrib => with[:attrib], :value => with[:value]} unless with.nil?
    end
  end

  def ainfo_delete
    condition(/^ainfo\s+(del|delete)\s+(?<object>.+)\s+@((?<attrib>\w|\.|\_)+)$/i) do |with|
      {:action => :ainfo, :command => :delete, :object => with[:object], :attrib => with[:attrib]} unless with.nil?
    end
  end

  def aifo_show
    condition(/^ainfo\s+(?<command>show|clear)\s+(?<object>.*)$/i) do |with|
      {:action => :ainof, :object => with[:object], :command => with[:command]} unless with.nil?
    end
  end

  def alook
    condition(/^alook$/i) do |with|
      {:action => :alook} unless with.nil?
    end
  end

end


#  when /^alook\s+(.*)$/i
#  event[:action] = :alook
#  event[:at] = $1
#  when /^alist$/i
#  event[:action] = :alist
#  when /^alist\s+(@\w+|class)\s+(.*)/i
#  event[:action] = :alist
#  event[:attrib] = $2
#  event[:match] = $1
#  when /^aset\s+(.+?)\s+(@\w+|smell|feel|texture|taste|sound|listen)\s+(.*)$/i
#  event[:action] = :aset
#  event[:object] = $1
#  event[:attribute] = $2
#  event[:value] = $3
#  when /^aset!\s+(.+?)\s+(@\w+|smell|feel|texture|taste|sound|listen)\s+(.*)$/i
#  event[:action] = :aset
#  event[:object] = $1
#  event[:attribute] = $2
#  event[:value] = $3
#  event[:force] = true
#  when /^aput\s+(.*?)\s+in\s+(.*?)$/i
#  event[:action] = :aput
#  event[:object] = $1
#  event[:in] = $2
#  when /^areas$/i
#  event[:action] = :areas
#  when /^areload\s+(.*)$/i
#  event[:action] = :areload
#  event[:object] = $1
#  when /^areact\s+load\s+(.*?)\s+(\w+)$/i
#  event[:action] = :areaction
#  event[:object] = $1
#  event[:command] = "load"
#  event[:file] = $2
#  when /^areact\s+(add|delete)\s+(.*?)\s+(\w+)$/i
#  event[:action] = :areaction
#  event[:object] = $2
#  event[:command] = $1
#  event[:action_name] = $3
#  when /^areact\s+(reload|clear|show)\s+(.*?)$/i
#  event[:action] = :areaction
#  event[:object] = $2
#  event[:command] = $1
#  when /^alog\s+(\w+)(\s+(\d+))?$/i
#  event[:action] = :alog
#  event[:command] = $1
#  event[:value] = $3.downcase if $3
#  when /^acopy\s+(.*)$/i
#  event[:action] = :acopy
#  event[:object] = $1
#  when /^alearn\s+(\w+)$/i
#  event[:action] = :alearn
#  event[:skill] = $1
#  when /^ateach\s+(\w+)\s+(\w+)$/i
#  event[:action] = :ateach
#  event[:target] = $1
#  event[:skill] = $2
#  when /^aforce\s+(.*?)\s+(.*)$/i
#  event[:action] = :aforce
#  event[:target] = $1
#  event[:command] = $2
#  when /^(acomm|acomment)\s+(.*?)\s+(.*)$/i
#  event[:action] = :acomment
#  event[:target] = $2
#  event[:comment] = $3
#  when /^awatch\s+((start|stop)\s+)?(.*)$/i
#  event[:action] = :awatch
#  event[:target] = $3.downcase if $3
#  event[:command] = $2.downcase if $2
#  when /^asave$/i
#  event[:action] = :asave
#  when /^restart$/i
#  event[:action] = :restart
#  when /^terrain\s+area\s+(.*)$/i
#  event[:action] = :terrain
#  event[:target] = "area"
#  event[:value] = $1
#  when /^terrain\s+(room|here)\s+(type|indoors|underwater|water)\s+(.*)$/
#  event[:action] = :terrain
#  event[:target] = "room"
#  event[:setting] = $2.downcase
#  event[:value] = $3
#  when /^whereis\s(.*)$/
#  event[:action] = :whereis
#  event[:object] = $1
#else