require File.dirname(__FILE__) + '/../../../components/commands/admin_commands'

describe AdminCommands do

  it "should return correct category" do
    AdminCommands.category.should == :Admin
  end

  it "should return correct command list" do
    AdminCommands.all_commands.should == Set.new(%w(acreate alook adesc acarea acopy acomment acomm aconfig acportal ahelp portal aset aset! adelete aforce ahide ashow ainfo aput alist alearn areas ateach areload areact awho alog astatus acroom acexit acdoor acprop asave awatch deleteplayer restart terrain whereis))
  end

  it "should find all commands in the command list" do
    AdminCommands.all_commands.each do |command|
      AdminCommands.has_this?(command).should == true
    end
  end

  it "should not find a command that is not in the command list" do
    AdminCommands.has_this?('command_not_present').should == false
  end

  it "should parse astatus" do
    assert_admin_command('astatus', :astatus, {:action => :astatus})
  end

  it "should parse ahelp" do
    assert_admin_command('ahelp log', :ahelp, {:action => :ahelp, :object => 'log'})
  end

  it "should parse awho" do
    assert_admin_command('awho', :awho, {:action => :awho})
  end

  it "should parse acreate" do
    assert_admin_command('acreate dog spot', :acreate, {:action => :acreate, :object => 'dog', :name => 'spot'})
  end

  it "should parse acarea" do
    assert_admin_command('acarea woop', :acarea, {:action => :acarea, :name => 'woop'})
  end

  it "should parse acroom" do
    assert_admin_command('acroom east lounge', :acroom, {:action => :acroom, :out_dir => 'east', :in_dir => 'west', :name => 'lounge'})
  end

  it "should parse acexit" do
    assert_admin_command('acexit west 1234', :acexit, {:action => :acreate, :object => 'exit', :alt_names => ['west'], :args => ['1234']})
  end

  it "should parse acdoor" do
    assert_admin_command('acdoor north', :acdoor, {:action => :acdoor, :direction => 'north'})
  end

  it "should parse acdoor_exit" do
    assert_admin_command('acdoor east lounge', :acdoor_exit, {:action => :acdoor, :direction => 'east', :exit_room => 'lounge'})
  end

  it "should parse aconfig_reload" do
    assert_admin_command('aconfig reload', :aconfig_reload, {:action => :aconfig, :setting => 'reload'})
  end

  it "should parse aconfig" do
    assert_admin_command('aconfig restart_delay 5', :aconfig, {:action => :aconfig, :setting => 'restart_delay', :value => '5'})
  end

  it "should parse acportal" do
    assert_admin_command('acportal climb 1234', :acportal, {:action => :acportal, :object => 'portal', :alt_names => [], :portal_action => ' 1234', :args => ['1234']})
  end

  it "should parse portal" do
    assert_admin_command('portal mirror exit um', :portal, {:action => :portal, :object => 'mirror', :setting => 'exit', :value => 'um'})
  end

  it "should parse acprop" do
    assert_admin_command('acprop cow', :acprop, {:action => :acreate, :object => 'prop', :generic => 'cow'})
  end

  it "should parse adelete" do
    assert_admin_command('adelete ship', :adelete, {:action => :adelete, :object => 'ship'})
  end

  it "should parse delete_player" do
    assert_admin_command('deleteplayer zorro', :delete_player, {:action => :delete_player, :object => 'zorro'})
  end

  it "should parse adesc" do
    assert_admin_command('adesc inroom sun yellow', :adesc, {:action => :adesc, :object => 'sun', :inroom => true, :desc => 'yellow'})
  end

  it "should parse adesc_plain" do
    assert_admin_command('adesc moon bright', :adesc_plain, {:action => :adesc, :object => 'moon', :desc => 'bright'})
  end

  it "should parse ahide" do
    assert_admin_command('ahide box', :ahide, {:action => :ahide, :object => 'box', :hide => true})
  end

  it "should parse ashow" do
    assert_admin_command('ashow broom', :ashow, {:action => :ahide, :object => 'broom', :hide => false})
  end

  it "should parse ainfo_set" do
    assert_admin_command('ainfo set person @address.city Cleveland', :ainfo_set, {:action => :ainfo, :command => :set, :object => 'person', :attrib => 'y', :value => 'Cleveland'})
  end

  it "should parse ainfo_delete" do
    assert_admin_command('ainfo delete person @address.city', :ainfo_delete, {:action => :ainfo, :command => :delete, :object => 'person', :attrib => 'y'})
  end

  it "should parse ainfo_show" do
    assert_admin_command('ainfo show boots', :ainfo_show, {:action => :ainfo, :object => 'boots', :command => 'show'})
  end

  it "should parse alook" do
    assert_admin_command('alook', :alook, {:action => :alook})
  end

  it "should parse alook_at" do
    assert_admin_command('alook car', :alook_at, {:action => :alook, :at => "car"})
  end

  it "should parse alist" do
    assert_admin_command('alist', :alist, {:action => :alist})
  end

  it "should parse alist_class" do
    assert_admin_command('alist class dog', :alist_class, {:action => :alist, :attrib => 'dog', :match => 'class'})
  end

  it "should parse aset" do
    assert_admin_command('aset dog @name spot', :aset, {:action => :aset, :object => 'dog', :attribute => '@name', :value => 'spot'})
  end

  it "should parse aset_force" do
    assert_admin_command('aset! dog @name spot', :aset_force, {:action => :aset, :object => 'dog', :attribute => '@name', :value => 'spot', :force => true})
  end

  it "should parse aput" do
    assert_admin_command('aput spoon in drawer', :aput, {:action => :aput, :object => 'spoon', :in => 'drawer'})
  end

  it "should parse areas" do
    assert_admin_command('areas', :areas, {:action => :areas})
  end

  it "should parse areload" do
    assert_admin_command('areload spoon', :areload, {:action => :areload, :object => 'spoon'})
  end

  it "should parse areact" do
    assert_admin_command('areact load file oar', :areact, {:action => :areaction, :object => 'file', :command => 'load', :file => 'oar'})
  end

  it "should parse areact_add" do
    assert_admin_command('areact add object action', :areact_add, {:action => :areaction, :object => 'object', :command => 'add', :action_name => 'action'})
  end

  it "should parse areact_reload" do
    assert_admin_command('areact reload dog', :areact_reload, {:action => :areaction, :object => 'dog', :command => 'reload'})
  end

  it "should parse alog" do
    assert_admin_command('alog system 50', :alog, {:action => :alog, :command => 'system', :value => '50'})
    assert_admin_command('alog player', :alog, {:action => :alog, :command => 'player', :value => nil})
  end

  it "should parse acopy" do
    assert_admin_command('acopy dog', :acopy, {:action => :acopy, :object => 'dog'})
  end

  it "should parse alearn" do
    assert_admin_command('alearn spells', :alearn, {:action => :alearn, :skill => 'spells'})
  end

  it "should parse ateach" do
    assert_admin_command('ateach moop running', :ateach, {:action => :ateach, :target => 'moop', :skill => 'running'})
  end

  it "should parse aforce" do
    assert_admin_command('aforce gary slap', :aforce, {:action => :aforce, :target => 'gary', :command => 'slap'})
  end

  it "should parse acomment" do
    assert_admin_command('acomment coq yikes', :acomment, {:action => :acomment, :target => "coq", :comment => "yikes"})
  end

  it "should parse awatch" do
    assert_admin_command('awatch start dog', :awatch, {:action => :awatch, :target => 'dog', :command => 'start'})
  end

  it "should parse asave" do
    assert_admin_command('asave', :asave, {:action => :asave})
  end

  it "should parse restart" do
    assert_admin_command('restart', :restart, {:action => :restart})
  end

  it "should parse terrain_area" do
    assert_admin_command('terrain area urban', :terrain_area, {:action => :terrain, :target => 'area', :value => 'urban'})
  end

  it "should parse terrain_room" do
    assert_admin_command('terrain here indoors yes', :terrain_room, {:action => :terrain, :target => 'room', :setting => 'indoors', :value => 'yes'})
  end

  it "should parse whereis" do
    assert_admin_command('whereis boomer', :whereis, {:action => :whereis, :object => 'boomer'})
  end


  def assert_admin_command(user_input, command, options)
    AdminCommands.new(user_input).send(command).should == options
  end


  #assert_admin_command('ahelp acroom', {:action => :ahelp, :object => ' acroom'})
  #assert_admin_command('awho', {:action => :awho})
  #assert_admin_command('acreate dog spot', {:action => :acreate, :object => 'dog', :name => 'spot'})
  #assert_admin_command('acarea The Lounge', {:action => :acarea, :name => 'The Lounge'})
  #assert_admin_command('acroom east The Lounge', {:action => :acroom, :out_dir => 'east', :in_dir => 'west', :name => 'The Lounge'})
  #assert_admin_command('acexit west The Lounge', {:action => :acreate, :alt_names => ['west'], :args => ['The Lounge'], :object => 'exit'})
  #assert_admin_command('acdoor south', {:action => :acdoor, :direction => 'south'})
  #assert_admin_command('aconfig restart_delay 5', {:action => :aconfig, :setting => 'restart_delay', :value => '5'})
  #assert_admin_command('aconfig reload', {:action => :aconfig, :setting => 'reload'})
  #assert_acportal %w(jump climb crawl enter)
  #assert_portal %w(action exit entrance portal)
  #assert_admin_command('acprop rock', {:action => :acreate, :object => 'prop', :generic => 'rock'})
  #assert_admin_command('adelete rock', {:action => :adelete, :object => 'rock'})
  #assert_admin_command('deleteplayer superman', {:action => :delete_player, :object => 'superman'})
  #assert_admin_command('adesc inroom rock true', {:action => :adesc, :object => 'rock', :inroom => true, :desc => 'true'})

end
