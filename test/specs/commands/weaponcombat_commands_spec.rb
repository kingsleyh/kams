require File.dirname(__FILE__) + '/../../../components/commands/weaponcombat_commands'

describe WeaponcombatCommands do

  it "it should parse wield" do
    assert_weapon_combat_command('wield sword', :wield, {:action => :wield, :weapon => 'sword', :side => nil})
    assert_weapon_combat_command('wield sword left', :wield, {:action => :wield, :weapon => 'sword', :side => 'left'})
  end

  it "should parse unwield" do
    assert_weapon_combat_command('unwield sword', :unwield, {:action => :unwield, :weapon => 'sword'})
  end

  it "should parse slash" do
    assert_weapon_combat_command('slash', :slash, {:action => :slash})
    assert_weapon_combat_command('slash maggie', :slash_target, {:action => :slash, :target => 'maggie'})
  end

  it "should parse block" do
    assert_weapon_combat_command('block', :block, {:action => :simple_block, :target => nil})
    assert_weapon_combat_command('block maggie', :block, {:action => :simple_block, :target => 'maggie'})
  end

  def assert_weapon_combat_command(user_input, command, options)
    WeaponcombatCommands.new(user_input).send(command).should == options
  end

end





