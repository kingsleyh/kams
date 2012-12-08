require File.dirname(__FILE__) + '/../../../components/commands/martialcombat_commands'

describe MartialcombatCommands do

  it "should return correct category" do
    MartialcombatCommands.category.should == :MartialCombat
  end

  it "should return correct command list" do
    MartialcombatCommands.all_commands.should ==  Set.new(%w(punch kick dodge))
  end

  it "should find all commands in the command list" do
    MartialcombatCommands.all_commands.each do |command|
      MartialcombatCommands.has_this?(command).should == true
    end
  end

  it "should not find a command that is not in the command list" do
    MartialcombatCommands.has_this?('command_not_present').should == false
  end

  it "it should parse punch" do
    assert_martial_combat_command('punch', :punch, {:action => :punch})
  end

  it "should parse punch target" do
    assert_martial_combat_command('punch maggie', :punch_target, {:action => :punch, :target => 'maggie'})
  end

  it "should parse kick" do
    assert_martial_combat_command('kick', :kick, {:action => :kick})
  end

  it "should parse kick target" do
    assert_martial_combat_command('kick maggie', :kick_target, {:action => :kick, :target => 'maggie'})
  end

  it "should parse dodge" do
    assert_martial_combat_command('dodge', :dodge, {:action => :simple_dodge, :target => nil})
    assert_martial_combat_command('dodge maggie', :dodge, {:action => :simple_dodge, :target => 'maggie'})
  end

  def assert_martial_combat_command(user_input, command, options)
    MartialcombatCommands.new(user_input).send(command).should == options
  end


end