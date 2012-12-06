require File.dirname(__FILE__) + '/../../components/manager'
require File.dirname(__FILE__) + '/../../components/command_parser'
require File.dirname(__FILE__) + '/../../objects/player'

$manager = Manager.new

describe CommandParser do

  before(:each) do
    @player = Player.new(self, nil, ServerConfig.start_room, "superman", [], "a typical person", "This is a normal, everyday kind of person.", "person", "f")
  end

  it "should parse generic commands" do
    assert_generic_command('delete me please', {:action => :deleteme})
    assert_issue %w(bug typo idea)
    assert_look %w(look l)
    assert_generic_command('lock it', {:action => :lock, :object => 'it'})
    assert_generic_command('unlock it', {:action => :unlock, :object => 'it'})
    assert_get %w(get grab take)
    assert_generic_command('give book to maggie', {:action => :give, :item => 'book', :to => 'maggie'})
    assert_inventory %w(i inv inventory)
    assert_generic_command('more', {:action => :more})
    assert_generic_command('open door', {:action => :open, :object => 'door'})
    assert_close %w(close shut)
    assert_generic_command('drop book', {:action => :drop, :object => 'book'})
    assert_generic_command('quit', {:action => :quit})
    assert_generic_command('put scroll in bag', {:action => :put, :item => 'scroll', :count => 0, :container => 'bag'})
    assert_generic_command('help', {:action => :help, :object => ""})
    assert_generic_command('health', {:action => :health})
    assert_generic_command('status', {:action => :status})
    assert_hunger %w(satiety hunger)
    assert_status %w(st stat status)
    assert_sense :listen, %w(listen)
    assert_sense :smell, %w(sniff smell)
    assert_sense :taste, %w(taste lick)
    assert_sense :feel, %w(feel)
    assert_generic_command('write something', {:action => :write, :target => "something"})
    assert_generic_command('who', {:action => :who})
    assert_generic_command('time', {:action => :time})
    assert_generic_command('date', {:action => :date})
  end

  it "should parse communication commands" do
    assert_communication_command('say (with interest) hello', {:action => :say, :phrase => 'hello', :pre => 'with interest'})
    assert_communication_command('say hello', {:action => :say, :phrase => 'hello', :pre => nil})
    assert_communication_command('sayto maggie hello', {:action => :say, :phrase => 'hello', :pre => nil, :target => 'maggie'})
    assert_communication_command('sayto maggie (with pride) hello', {:action => :say, :phrase => 'hello', :pre => 'with pride', :target => 'maggie'})
    assert_communication_command('whisper maggie (with interest) hello', {:action => :whisper, :phrase => 'hello', :pre => 'with interest', :to => 'maggie'})
    assert_communication_command('whisper maggie hello', {:action => :whisper, :phrase => 'hello', :pre => nil, :to => 'maggie'})
    assert_communication_command('tell maggie hello', {:action => :tell, :message => 'hello', :target => 'maggie'})
    assert_communication_command('reply hello', {:action => :reply, :message => 'hello'})
  end

  it "should parse emote commands" do
    assert_fixed_emote %w(uh er eh? eh shrug sigh ponder agree cry hug pet smile laugh ew blush grin frown snicker wave poke yes no huh hi bye yawn bow curtsey brb skip nod back cheer hm)
    assert_emote_command('emote sings happily', {:action => :emote, :show => 'sings happily'})
  end

  it "should parse movement commands" do
    assert_movement_command('gait clumsily', {:action => :gait, :phrase => 'clumsily'})
    assert_movement_command('gait', {:action => :gait})
    assert_movement_command('go west', {:action => :move, :direction => "west"})
    assert_enter %w(jump climb crawl enter)
    assert_movement_command('sit on chair', {:action => :sit, :object => "chair"})
    assert_movement_command('sit chair', {:action => :sit, :object => "chair"})
    assert_movement_command('sit', {:action => :sit})
    assert_movement_command('pose tall', {:action => :pose, :pose => 'tall'})
    assert_movement_command('stand', {:action => :stand})
    assert_direction %w(east west northeast northwest north southeast southwest south e w nw ne sw se n s up down u d in out)
  end

  it "should parse equipment commands" do
    assert_equip_command('wear shirt', {:action => :wear, :object => 'shirt', :position => nil})
    assert_equip_command('wear shirt on torso', {:action => :wear, :object => 'shirt', :position => 'torso'})
    assert_equip_command('remove shirt', {:action => :remove, :object => 'shirt', :position => nil})
    assert_equip_command('remove shirt from torso', {:action => :remove, :object => 'shirt', :position => 'torso'})
  end

  it "should parse settings commands" do
    assert_settings_command('set colors on', {:action => :setcolor, :option => 'on'})
    assert_settings_command('set colors off', {:action => :setcolor, :option => 'off'})
    assert_settings_command('set colors default', {:action => :setcolor, :option => 'default'})
    assert_settings_command('set colors say red', {:action => :setcolor, :option => 'say', :color => 'red'})
    assert_settings_command('set colors', {:action => :showcolors})
    assert_settings_command('set password', {:action => :setpassword})
    assert_settings_command('set wordwrap off', {:action => :set, :setting => 'wordwrap', :value => 'off'})
  end

  it "should parse weapon combat commands" do
    assert_weapon_combat_command('wield sword', {:action => :wield, :weapon => 'sword', :side => nil})
    assert_weapon_combat_command('wield sword left', {:action => :wield, :weapon => 'sword', :side => 'left'})
    assert_weapon_combat_command('unwield sword', {:action => :unwield, :weapon => 'sword'})
    assert_weapon_combat_command('slash', {:action => :slash, :target => nil})
    assert_weapon_combat_command('slash maggie', {:action => :slash, :target => 'maggie'})
    assert_weapon_combat_command('block', {:action => :simple_block, :target => nil})
    assert_weapon_combat_command('block maggie', {:action => :simple_block, :target => 'maggie'})
  end

  it "should parse martial combat commands" do
    assert_martial_combat_command('punch', {:action => :punch})
    assert_martial_combat_command('punch maggie', {:action => :punch, :target => 'maggie'})
    assert_martial_combat_command('kick', {:action => :kick})
    assert_martial_combat_command('kick maggie', {:action => :kick, :target => 'maggie'})
    assert_martial_combat_command('dodge', {:action => :simple_dodge})
    assert_martial_combat_command('dodge maggie', {:action => :simple_dodge, :target => 'maggie'})
  end

  it "should parse custom commands" do
    assert_custom_command('slide up', {:action => :custom, :custom_action => 'slide', :target => 'up'})
  end

  it "should parse news commands" do
    assert_news_command('news', {:action => :latest_news})
    assert_news_command('news last 2', {:action => :latest_news, :limit => 2})
    assert_news_command('news read 1', {:action => :read_post, :post_id => "1"})
    assert_news_command('news 1', {:action => :read_post, :post_id => "1"})
    assert_news_command('news write', {:action => :write_post})
    assert_news_command('news reply 1', {:action => :write_post, :reply_to => "1"})
    assert_news_command('news delete 1', {:action => :delete_post, :post_id => "1"})
    assert_news_command('news unread', {:action => :list_unread})
    assert_news_command('news all', {:action => :all})
  end

  it "should parse admin commands" do
    @player.enable_admin
    assert_admin_command('astatus', {:action => :astatus})
    assert_admin_command('ahelp acroom', {:action => :ahelp, :object => ' acroom'})
    assert_admin_command('awho', {:action => :awho})
    assert_admin_command('acreate dog spot', {:action => :acreate, :object => 'dog', :name => 'spot'})
    assert_admin_command('acarea The Lounge', {:action => :acarea, :name => 'The Lounge'})
    assert_admin_command('acroom east The Lounge', {:action => :acroom, :out_dir => 'east', :in_dir => 'west', :name => 'The Lounge'})
    assert_admin_command('acexit west The Lounge', {:action => :acreate, :alt_names => ['west'], :args => ['The Lounge'], :object => 'exit'})
    assert_admin_command('acdoor south', {:action => :acdoor, :direction => 'south'})
    assert_admin_command('aconfig restart_delay 5', {:action => :aconfig, :setting => 'restart_delay', :value => '5'})
    assert_admin_command('aconfig reload', {:action => :aconfig, :setting => 'reload'})
    assert_acportal %w(jump climb crawl enter)
    assert_portal %w(action exit entrance portal)
    assert_admin_command('acprop rock', {:action => :acreate, :object => 'prop', :generic => 'rock'})
    assert_admin_command('adelete rock', {:action => :adelete, :object => 'rock'})
    assert_admin_command('deleteplayer superman', {:action => :delete_player, :object => 'superman'})
    assert_admin_command('adesc inroom rock true', {:action => :adesc, :object => 'rock', :inroom => true, :desc => 'true'})
  end


  #     when /^adesc\s+(.*?)\s+(.*)$/i
  #       event[:action] = :adesc
  #       event[:object] = $1
  #       event[:desc] = $2
  #     when /^ahide\s+(.*)$/i
  #       event[:action] = :ahide
  #       event[:object] = $1
  #       event[:hide] = true
  #     when /^ashow\s+(.*)$/i
  #       event[:action] = :ahide
  #       event[:object] = $1
  #       event[:hide] = false
  #     when /^ainfo\s+set\s+(.+)\s+@((\w|\.|\_)+)\s+(.*?)$/i
  #       event[:action] = :ainfo
  #       event[:command] = "set"
  #       event[:object] = $1
  #       event[:attrib] = $2
  #       event[:value] = $4
  #     when /^ainfo\s+(del|delete)\s+(.+)\s+@((\w|\.|\_)+)$/i
  #       event[:action] = :ainfo
  #       event[:command] = "delete"
  #       event[:object] = $2
  #       event[:attrib] = $3
  #     when /^ainfo\s+(show|clear)\s+(.*)$/i
  #       event[:action] = :ainfo
  #       event[:object] = $2
  #       event[:command] = $1
  #     when /^alook$/i
  #       event[:action] = :alook
  #     when /^alook\s+(.*)$/i
  #       event[:action] = :alook
  #       event[:at] = $1
  #     when /^alist$/i
  #       event[:action] = :alist
  #     when /^alist\s+(@\w+|class)\s+(.*)/i
  #       event[:action] = :alist
  #       event[:attrib] = $2
  #       event[:match] = $1
  #     when /^aset\s+(.+?)\s+(@\w+|smell|feel|texture|taste|sound|listen)\s+(.*)$/i
  #       event[:action] = :aset
  #       event[:object] = $1
  #       event[:attribute] = $2
  #       event[:value] = $3
  #     when /^aset!\s+(.+?)\s+(@\w+|smell|feel|texture|taste|sound|listen)\s+(.*)$/i
  #       event[:action] = :aset
  #       event[:object] = $1
  #       event[:attribute] = $2
  #       event[:value] = $3
  #       event[:force] = true
  #     when /^aput\s+(.*?)\s+in\s+(.*?)$/i
  #       event[:action] = :aput
  #       event[:object] = $1
  #       event[:in] = $2
  #     when /^areas$/i
  #       event[:action] = :areas
  #     when /^areload\s+(.*)$/i
  #       event[:action] = :areload
  #       event[:object] = $1
  #     when /^areact\s+load\s+(.*?)\s+(\w+)$/i
  #       event[:action] = :areaction
  #       event[:object] = $1
  #       event[:command] = "load"
  #       event[:file] = $2
  #     when /^areact\s+(add|delete)\s+(.*?)\s+(\w+)$/i
  #       event[:action] = :areaction
  #       event[:object] = $2
  #       event[:command] = $1
  #       event[:action_name] = $3
  #     when /^areact\s+(reload|clear|show)\s+(.*?)$/i
  #       event[:action] = :areaction
  #       event[:object] = $2
  #       event[:command] = $1
  #     when /^alog\s+(\w+)(\s+(\d+))?$/i
  #       event[:action] = :alog
  #       event[:command] = $1
  #       event[:value] = $3.downcase if $3
  #     when /^acopy\s+(.*)$/i
  #       event[:action] = :acopy
  #       event[:object] = $1
  #     when /^alearn\s+(\w+)$/i
  #       event[:action] = :alearn
  #       event[:skill] = $1
  #     when /^ateach\s+(\w+)\s+(\w+)$/i
  #       event[:action] = :ateach
  #       event[:target] = $1
  #       event[:skill] = $2
  #     when /^aforce\s+(.*?)\s+(.*)$/i
  #       event[:action] = :aforce
  #       event[:target] = $1
  #       event[:command] = $2
  #     when /^(acomm|acomment)\s+(.*?)\s+(.*)$/i
  #       event[:action] = :acomment
  #       event[:target] = $2
  #       event[:comment] = $3
  #     when /^awatch\s+((start|stop)\s+)?(.*)$/i
  #       event[:action] = :awatch
  #       event[:target] = $3.downcase if $3
  #       event[:command] = $2.downcase if $2
  #     when /^asave$/i
  #       event[:action] = :asave
  #     when /^restart$/i
  #       event[:action] = :restart
  #     when /^terrain\s+area\s+(.*)$/i
  #       event[:action] = :terrain
  #       event[:target] = "area"
  #       event[:value] = $1
  #     when /^terrain\s+(room|here)\s+(type|indoors|underwater|water)\s+(.*)$/
  #       event[:action] = :terrain
  #       event[:target] = "room"
  #       event[:setting] = $2.downcase
  #       event[:value] = $3
  #     when /^whereis\s(.*)$/
  #       event[:action] = :whereis
  #       event[:object] = $1
  #     else
  #       return nil
  #     end

  private
  def assert_issue(issue_types)
    issue_types.each do |issue_type|
      assert_generic_command(issue_type + ' broke it', {:action => :issue, :itype => issue_type.to_sym, :option => "new", :value => 'broke it'})
      assert_generic_command(issue_type + ' 1', {:action => :issue, :itype => issue_type.to_sym, :option => "show", :issue_id => "1"})
      assert_generic_command(issue_type + ' list', {:action => :issue, :itype => issue_type.to_sym, :option => "list", :value => nil})
      assert_generic_command(issue_type + ' 1 status', {:action => :issue, :itype => issue_type.to_sym, :option => "status", :issue_id => "1", :value => nil})
      assert_generic_command(issue_type + ' show 1', {:action => :issue, :itype => issue_type.to_sym, :option => "show", :issue_id => "1", :value => nil})
      assert_generic_command(issue_type + ' add 1 oops', {:action => :issue, :itype => issue_type.to_sym, :option => "add", :issue_id => "1", :value => "oops"})
      assert_generic_command(issue_type + ' del 1', {:action => :issue, :itype => issue_type.to_sym, :option => "del", :issue_id => "1", :value => nil})
    end
  end

  def assert_look(commands)
    commands.each do |command|
      assert_generic_command(command, {:action => :look})
      assert_generic_command(command + ' in', {:action => :look, :at => 'in'})
      assert_generic_command(command + ' inside', {:action => :look, :at => 'inside'})
      assert_generic_command(command + ' inside it', {:action => :look, :in => 'it'})
    end
  end

  def assert_get(commands)
    commands.each do |command|
      assert_generic_command(command + ' it', {:action => :get, :object => 'it', :from => nil})
      assert_generic_command(command + ' it from table', {:action => :get, :object => 'it', :from => 'table'})
    end
  end

  def assert_inventory(commands)
    commands.each do |command|
      assert_generic_command(command, {:action => :show_inventory})
    end
  end

  def assert_close(commands)
    commands.each do |command|
      assert_generic_command(command + ' door', {:action => :close, :object => 'door'})
    end
  end

  def assert_hunger(commands)
    commands.each do |command|
      assert_generic_command(command, {:action => :satiety})
    end
  end

  def assert_status(commands)
    commands.each do |command|
      assert_generic_command(command, {:action => :status})
    end
  end

  def assert_sense(sense, commands)
    commands.each do |command|
      assert_generic_command(command, {:action => sense, :target => nil})
      assert_generic_command(command + ' tree', {:action => sense, :target => 'tree'})
    end
  end

  def assert_fixed_emote(commands)
    commands.each do |command|
      assert_emote_command(command, {:action => command.to_sym, :object => nil, :post => nil})
      assert_emote_command(command + ' maggie', {:action => command.to_sym, :object => 'maggie', :post => nil})
      assert_emote_command(command + ' maggie (loudly)', {:action => command.to_sym, :object => 'maggie', :post => 'loudly'})
    end
  end

  def assert_enter(commands)
    commands.each do |command|
      assert_movement_command(command + ' west', {:action => :enter, :portal_action => command, :object => 'west'})
    end
  end

  def assert_direction(commands)
    commands.each do |command|
      assert_movement_command(command, {:action => :move, :direction => expand_direction(command), :pre => nil})
      assert_movement_command(command + ' (smiling)', {:action => :move, :direction => expand_direction(command), :pre => 'smiling'})
    end
  end

  def assert_acportal(commands)
    commands.each do |command|
      assert_admin_command('acportal climb d635469-7660-b99b-1764-cc95b9ec5f37', {:action => :acportal, :object => 'portal', :alt_names => [], :args => ["d635469-7660-b99b-1764-cc95b9ec5f37"]})
    end
  end

  def assert_portal(commands)
    commands.each do |command|
      assert_admin_command('portal object ' + command + ' enter', {:action => :portal, :object => 'object', :setting => command, :value => 'enter'})
    end
  end

  def assert_generic_command(command, options)
    parser = CommandParser.parse(@player, command)
    options.each do |key, value|
      parser.send(key).should == value
      parser.type.should == :Generic
      parser.player.should == @player
    end
  end

  def assert_communication_command(command, options)
    parser = CommandParser.parse(@player, command)
    options.each do |key, value|
      parser.send(key).should == value
      parser.type.should == :Communication
      parser.player.should == @player
    end
  end

  def assert_emote_command(command, options)
    parser = CommandParser.parse(@player, command)
    options.each do |key, value|
      parser.send(key).should == value
      parser.type.should == :Emote
      parser.player.should == @player
    end
  end

  def assert_movement_command(command, options)
    parser = CommandParser.parse(@player, command)
    options.each do |key, value|
      parser.send(key).should == value
      parser.type.should == :Movement
      parser.player.should == @player
    end
  end

  def assert_equip_command(command, options)
    parser = CommandParser.parse(@player, command)
    options.each do |key, value|
      parser.send(key).should == value
      parser.type.should == :Clothing
      parser.player.should == @player
    end
  end

  def assert_settings_command(command, options)
    parser = CommandParser.parse(@player, command)
    options.each do |key, value|
      parser.send(key).should == value
      parser.type.should == :Settings
      parser.player.should == @player
    end
  end

  def assert_weapon_combat_command(command, options)
    parser = CommandParser.parse(@player, command)
    options.each do |key, value|
      parser.send(key).should == value
      parser.type.should == :WeaponCombat
      parser.player.should == @player
    end
  end

  def assert_martial_combat_command(command, options)
    parser = CommandParser.parse(@player, command)
    options.each do |key, value|
      parser.send(key).should == value
      parser.type.should == :MartialCombat
      parser.player.should == @player
    end
  end

  def assert_custom_command(command, options)
    parser = CommandParser.parse(@player, command)
    options.each do |key, value|
      parser.send(key).should == value
      parser.type.should == :Custom
      parser.player.should == @player
    end
  end

  def assert_news_command(command, options)
    parser = CommandParser.parse(@player, command)
    options.each do |key, value|
      parser.send(key).should == value
      parser.type.should == :News
      parser.player.should == @player
    end
  end

  def assert_admin_command(command, options)
    parser = CommandParser.parse(@player, command)
    options.each do |key, value|
      parser.send(key).should == value
      parser.type.should == :Admin
      parser.player.should == @player
    end
  end

end
