require File.dirname(__FILE__) + '/../../../components/commands/generic_commands'

describe GenericCommands do

  it "should return correct category" do
    GenericCommands.category.should == :Generic
  end

  it "should return correct command list" do
    GenericCommands.all_commands.should == Set.new(%w(bug date delete look l get take feel idea taste smell sniff lick listen grab give health hunger satiety i inv inventory more quit open close shut drop put help lock unlock status stat st time typo who write))
  end

  it "should find all commands in the command list" do
    GenericCommands.all_commands.each do |command|
      GenericCommands.has_this?(command).should == true
    end
  end

  it "should not find a command that is not in the command list" do
    GenericCommands.has_this?('command_not_present').should == false
  end

  it "it should parse delete me please" do
    assert_generic_command('delete me please', :delete_me_please, {:action => :deleteme})
  end

  it "it should parse bug, typo and idea" do
    assert_issue %w(bug)
  end

  it "should parse look commands" do
    assert_look %w(look l)
  end

  it "should parse lock" do
    assert_generic_command('lock it', :lock, {:action => :lock, :object => 'it'})
  end

  it "should parse unlock" do
    assert_generic_command('unlock it', :unlock, {:action => :unlock, :object => 'it'})
  end

  it "should parse get,grab and take" do
    assert_get %w(get grab take)
  end

  it "should parse give" do
    assert_generic_command('give book to maggie', :give, {:action => :give, :item => 'book', :to => 'maggie'})
  end

  it "should parse inventory" do
    assert_inventory %w(i inv inventory)
  end

  it "should parse more" do
    assert_generic_command('more', :more, {:action => :more})
  end

  it "should parse open" do
    assert_generic_command('open door', :open, {:action => :open, :object => 'door'})
  end

  it "should parse close" do
    assert_close %w(close shut)
  end

  it "should parse drop" do
    assert_generic_command('drop book', :drop, {:action => :drop, :object => 'book'})
  end

  it "should parse quit" do
    assert_generic_command('quit', :quit, {:action => :quit})
  end

  it "should parse put" do
    assert_generic_command('put scroll in bag', :put, {:action => :put, :item => 'scroll', :count => 0, :container => 'bag'})
  end

  it "should parse help" do
    assert_generic_command('help', :help, {:action => :help, :object => ""})
    assert_generic_command('help bug', :help, {:action => :help, :object => "bug"})
  end

  it "should parse health" do
    assert_generic_command('health', :health, {:action => :health})
  end

  it "should parse status" do
    %w(st stat status).each do |command|
      assert_generic_command(command, :status, {:action => :status})
    end
  end

  it "should parse hunger" do
    %w(hunger satiety).each do |command|
      assert_generic_command(command, :hunger, {:action => :satiety})
    end
  end

  it "should parse sense" do
    assert_sense :listen, %w(listen)
    assert_sense :smell, %w(sniff smell)
    assert_sense :taste, %w(taste lick)
    assert_sense :feel, %w(feel)
  end

  it "should parse write" do
    assert_generic_command('write something', :write, {:action => :write, :target => "something"})
  end

  it "should parse who" do
    assert_generic_command('who', :who, {:action => :who})
  end

  it "should parse time" do
    assert_generic_command('time', :time, {:action => :time})
  end

  it "should parse date" do
    assert_generic_command('date', :date, {:action => :date})
  end

  def assert_generic_command(user_input, command, options)
    GenericCommands.new(user_input).send(command).should == options
  end

  def assert_issue(issue_types)
    issue_types.each do |issue_type|
      assert_generic_command(issue_type + ' broke it', :issue_create_simple, {:action => :issue, :itype => issue_type.to_sym, :option => "new", :value => 'broke it'})
      assert_generic_command(issue_type + ' 1', :issue_show, {:action => :issue, :itype => issue_type.to_sym, :option => "show", :issue_id => "1"})
      assert_generic_command(issue_type + ' list', :issue_show_reverse, {:action => :issue, :itype => issue_type.to_sym, :option => "list", :value => nil})
      assert_generic_command(issue_type + ' 1 status', :issue_create, {:action => :issue, :itype => issue_type.to_sym, :option => "status", :issue_id => "1", :value => nil})
      assert_generic_command(issue_type + ' show 1', :issue_create_reverse, {:action => :issue, :itype => issue_type.to_sym, :option => "show", :issue_id => "1", :value => nil})
      assert_generic_command(issue_type + ' add 1 oops', :issue_create_reverse, {:action => :issue, :itype => issue_type.to_sym, :option => "add", :issue_id => "1", :value => "oops"})
      assert_generic_command(issue_type + ' del 1', :issue_create_reverse, {:action => :issue, :itype => issue_type.to_sym, :option => "del", :issue_id => "1", :value => nil})
    end
  end

  def assert_look(commands)
    commands.each do |command|
      assert_generic_command(command, :look, {:action => :look})
      assert_generic_command(command + ' in', :look_at, {:action => :look, :at => 'in'})
      assert_generic_command(command + ' inside', :look_at, {:action => :look, :at => 'inside'})
      assert_generic_command(command + ' inside it', :look_in, {:action => :look, :in => 'it'})
    end
  end

  def assert_get(commands)
    commands.each do |command|
      assert_generic_command(command + ' it', :get, {:action => :get, :object => 'it'})
      assert_generic_command(command + ' it from table', :get_from, {:action => :get, :object => 'it', :from => 'table'})
    end
  end

  def assert_inventory(commands)
    commands.each do |command|
      assert_generic_command(command, :inventory, {:action => :show_inventory})
    end
  end

  def assert_close(commands)
    commands.each do |command|
      assert_generic_command(command + ' door', :close, {:action => :close, :object => 'door'})
    end
  end

  def assert_sense(sense, commands)
    commands.each do |command|
      assert_generic_command(command, :sense, {:action => sense, :target => nil})
      assert_generic_command(command + ' tree', :sense, {:action => sense, :target => 'tree'})
    end
  end

end
