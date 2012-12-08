require File.dirname(__FILE__) + '/commands'
require File.dirname(__FILE__) + '/../../lib/util'

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
      {:action => :ahelp, :object => with[:object].strip} unless with.nil?
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
      {:action => :acroom, :out_dir => with[:out_dir], :in_dir => opposite_dir(with[:out_dir]), :name => with[:name]} unless with.nil?
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
    condition(/^ashow\s+(?<object>.*)$/i) do |with|
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

  def ainfo_show
    condition(/^ainfo\s+(?<command>show|clear)\s+(?<object>.*)$/i) do |with|
      {:action => :ainfo, :object => with[:object], :command => with[:command]} unless with.nil?
    end
  end

  def alook
    condition(/^alook$/i) do |with|
      {:action => :alook} unless with.nil?
    end
  end

  def alook_at
    condition(/^alook\s+(?<at>.*)$/i) do |with|
      {:action => :alook, :at => with[:at]} unless with.nil?
    end
  end

  def alist
    condition(/^alist$/i) do |with|
      {:action => :alist} unless with.nil?
    end
  end

  def alist_class
    condition(/^alist\s+(?<match>@\w+|class)\s+(?<attrib>.*)/i) do |with|
      {:action => :alist, :attrib => with[:attrib], :match => with[:match]} unless with.nil?
    end
  end

  def aset
    condition(/^aset\s+(?<object>.+?)\s+(?<attribute>@\w+|smell|feel|texture|taste|sound|listen)\s+(?<value>.*)$/i) do |with|
      {:action => :aset, :object => with[:object], :attribute => with[:attribute], :value => with[:value]} unless with.nil?
    end
  end

  def aset_force
    condition(/^aset!\s+(?<object>.+?)\s+(?<attribute>@\w+|smell|feel|texture|taste|sound|listen)\s+(?<value>.*)$/i) do |with|
      {:action => :aset, :object => with[:object], :attribute => with[:attribute], :value => with[:value], :force => true} unless with.nil?
    end
  end

  def aput
    condition(/^aput\s+(?<object>.*?)\s+in\s+(?<in>.*?)$/i) do |with|
      {:action => :aput, :object => with[:object], :in => with[:in]} unless with.nil?
    end
  end

  def areas
    condition(/^areas$/i) do |with|
      {:action => :areas} unless with.nil?
    end
  end

  def areload
    condition(/^areload\s+(?<object>.*)$/i) do |with|
      {:action => :areload, :object => with[:object]} unless with.nil?
    end
  end

  def areact
    condition(/^areact\s+load\s+(?<object>.*?)\s+(?<file>\w+)$/i) do |with|
      {:action => :areaction, :object => with[:object], :command => 'load', :file => with[:file]} unless with.nil?
    end
  end

  def areact_add
    condition(/^areact\s+(?<command>add|delete)\s+(?<object>.*?)\s+(?<action_name>\w+)$/i) do |with|
      {:action => :areaction, :object => with[:object], :command => with[:command], :action_name => with[:action_name]} unless with.nil?
    end
  end

  def areact_reload
    condition(/^areact\s+(?<command>reload|clear|show)\s+(?<object>.*?)$/i) do |with|
      {:action => :areaction, :object => with[:object], :command => with[:command]} unless with.nil?
    end
  end

  def alog
    condition(/^alog\s+(?<command>\w+)(\s+(?<value>\d+))?$/i) do |with|
      {:action => :alog, :command => with[:command], :value => with[:value].andand.downcase} unless with.nil?
    end
  end

  def acopy
    condition(/^acopy\s+(?<object>.*)$/i) do |with|
      {:action => :acopy, :object => with[:object]} unless with.nil?
    end
  end

  def alearn
    condition(/^alearn\s+(?<skill>\w+)$/i) do |with|
      {:action => :alearn, :skill => with[:skill]} unless with.nil?
    end
  end

  def ateach
    condition(/^ateach\s+(?<target>\w+)\s+(?<skill>\w+)$/i) do |with|
      {:action => :ateach, :target => with[:target], :skill => with[:skill]} unless with.nil?
    end
  end

  def aforce
    condition(/^aforce\s+(?<target>.*?)\s+(?<command>.*)$/i) do |with|
      {:action => :aforce, :target => with[:target], :command => with[:command]} unless with.nil?
    end
  end

  def acomment
    condition(/^(acomm|acomment)\s+(?<target>.*?)\s+(?<comment>.*)$/i) do |with|
      {:action => :acomment, :target => with[:target], :comment => with[:comment]} unless with.nil?
    end
  end

  def awatch
    condition(/^awatch\s+((?<command>start|stop)\s+)?(?<target>.*)$/i) do |with|
      {:action => :awatch, :target => with[:target].andand.downcase, :command => with[:command].andand.downcase} unless with.nil?
    end
  end

  def asave
    condition(/^asave$/i) do |with|
      {:action => :asave} unless with.nil?
    end
  end

  def restart
    condition(/^restart$/i) do |with|
      {:action => :restart} unless with.nil?
    end
  end

  def terrain_area
    condition(/^terrain\s+area\s+(?<value>.*)$/i) do |with|
      {:action => :terrain, :target => 'area', :value => with[:value]} unless with.nil?
    end
  end

  def terrain_room
    condition(/^terrain\s+(room|here)\s+(?<setting>type|indoors|underwater|water)\s+(?<value>.*)$/) do |with|
      {:action => :terrain, :target => 'room', :setting => with[:setting], :value => with[:value].andand.downcase} unless with.nil?
    end
  end

  def whereis
    condition(/^whereis\s(?<object>.*)$/) do |with|
      {:action => :whereis, :object => with[:object]} unless with.nil?
    end
  end
end
