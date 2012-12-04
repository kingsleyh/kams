require File.dirname(__FILE__) + '/../../components/manager'
require File.dirname(__FILE__) + '/../../components/command_parser'
require File.dirname(__FILE__) + '/../../objects/player'
require File.dirname(__FILE__) + '/helpers/commands'

$manager = Manager.new

describe CommandParser do

  before(:each) do
    @player = Player.new(self, nil, ServerConfig.start_room, "superman", [], "a typical person", "This is a normal, everyday kind of person.", "person", "f")
  end

  it "should parse generic commands" do
    assert_generic_command(@player, 'delete me please', {:action => :deleteme})
    assert_issue %w(bug typo idea)
    assert_look %w(look l)
    assert_generic_command(@player, 'lock it', {:action => :lock, :object => 'it'})
    assert_generic_command(@player, 'unlock it', {:action => :unlock, :object => 'it'})
    assert_get %w(get grab take)
  end

  private
  def assert_issue(issue_types)
    issue_types.each do |issue_type|
      assert_generic_command(@player, issue_type + ' broke it', {:action => :issue, :itype => issue_type.to_sym, :option => "new", :value => 'broke it'})
      assert_generic_command(@player, issue_type + ' 1', {:action => :issue, :itype => issue_type.to_sym, :option => "show", :issue_id => "1"})
      assert_generic_command(@player, issue_type + ' list', {:action => :issue, :itype => issue_type.to_sym, :option => "list", :value => nil})
      assert_generic_command(@player, issue_type + ' 1 status', {:action => :issue, :itype => issue_type.to_sym, :option => "status", :issue_id => "1", :value => nil})
      assert_generic_command(@player, issue_type + ' show 1', {:action => :issue, :itype => issue_type.to_sym, :option => "show", :issue_id => "1", :value => nil})
      assert_generic_command(@player, issue_type + ' add 1 oops', {:action => :issue, :itype => issue_type.to_sym, :option => "add", :issue_id => "1", :value => "oops"})
      assert_generic_command(@player, issue_type + ' del 1', {:action => :issue, :itype => issue_type.to_sym, :option => "del", :issue_id => "1", :value => nil})
    end
  end

  def assert_look(commands)
    commands.each do |command|
      assert_generic_command(@player, command, {:action => :look})
      assert_generic_command(@player, command + ' in', {:action => :look, :at => 'in'})
      assert_generic_command(@player, command + ' inside', {:action => :look, :at => 'inside'})
      assert_generic_command(@player, command + ' inside it', {:action => :look, :in => 'it'})
    end
  end

  def assert_get(commands)
    commands.each do |command|
      assert_generic_command(@player, command + ' it', {:action => :get, :object => 'it', :from => nil})
      assert_generic_command(@player, command + ' it from table', {:action => :get, :object => 'it', :from => 'table'})
    end
  end

  def assert_generic_command(player, command, options)
    p command
    p parser = CommandParser.parse(player, command)
    options.each do |key, value|
      parser.send(key).should == value
      parser.type.should == :Generic
      parser.player.should == player
    end
  end
end
