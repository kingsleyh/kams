require File.dirname(__FILE__) + '/../../../components/commands/movement_commands'

describe MovementCommands do

  it "should return correct category" do
    MovementCommands.category.should == :Movement
  end

  it "should return correct command list" do
    MovementCommands.all_commands.should == Set.new(%w(go east e west w south s north n up u down d northeast ne northwest nw southeast se southwest sw in out sit stand pose enter climb jump crawl gait))
  end

  it "should find all commands in the command list" do
    MovementCommands.all_commands.each do |command|
      MovementCommands.has_this?(command).should == true
    end
  end

  it "should not find a command that is not in the command list" do
    MovementCommands.has_this?('command_not_present').should == false
  end

  it "it should parse gait" do
    assert_movement_command('gait clumsily', :gait, {:action => :gait, :phrase => 'clumsily'})
  end

  it "should parse go" do
    assert_movement_command('go west', :go, {:action => :move, :direction => "west"})
  end

  it "should parse enter" do
    assert_enter %w(jump climb crawl enter)
  end

  it "should parse sit" do
    assert_movement_command('sit on chair', :sit_on, {:action => :sit, :object => "chair"})
    assert_movement_command('sit chair', :sit_target, {:action => :sit, :object => "chair"})
    assert_movement_command('sit', :sit, {:action => :sit})
  end

  it "should parse pose" do
    assert_movement_command('pose tall', :pose, {:action => :pose, :pose => 'tall'})
  end

  it "should parse stand" do
    assert_movement_command('stand', :stand, {:action => :stand})
  end

  it "should parse direction" do
    assert_direction %w(east west northeast northwest north southeast southwest south e w nw ne sw se n s up down u d in out)
  end

  #it "should parse jump portal" do
  #  pending
  #end

  def assert_movement_command(user_input, command, options)
    MovementCommands.new(user_input).send(command).should == options
  end

  def assert_enter(commands)
    commands.each do |command|
      assert_movement_command(command + ' west', :enter, {:action => :enter, :portal_action => command, :object => 'west'})
    end
  end

  def assert_direction(commands)
    commands.each do |command|
      assert_movement_command(command, :move, {:action => :move, :direction => MovementCommands.expand_direction(command), :pre => nil})
      assert_movement_command(command + ' (smiling)', :move, {:action => :move, :direction => MovementCommands.expand_direction(command), :pre => 'smiling'})
    end
  end

end







