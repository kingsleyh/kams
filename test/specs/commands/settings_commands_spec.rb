require File.dirname(__FILE__) + '/../../../components/commands/settings_commands'

describe SettingsCommands do

  it "it should parse enable colours" do
    assert_settings_command('set colors on', :enable_colours, {:action => :setcolor, :option => 'on'})
    assert_settings_command('set colors off', :enable_colours, {:action => :setcolor, :option => 'off'})
    assert_settings_command('set colors default', :enable_colours, {:action => :setcolor, :option => 'default'})
  end

  it "should parse set colours" do
    assert_settings_command('set colors say red', :set_colours, {:action => :setcolor, :option => 'say', :color => 'red'})
  end

  it "should parse show colours" do
    assert_settings_command('set colors', :show_colours, {:action => :showcolors})
  end

  it "should parse set password" do
    assert_settings_command('set password', :set_password, {:action => :setpassword})
  end

  it "should parse set" do
    assert_settings_command('set wordwrap off', :set, {:action => :set, :setting => 'wordwrap', :value => 'off'})
  end

  def assert_settings_command(user_input, command, options)
    SettingsCommands.new(user_input).send(command).should == options
  end

end