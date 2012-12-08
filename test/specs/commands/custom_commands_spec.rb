require File.dirname(__FILE__) + '/../../../components/commands/custom_commands'

describe CustomCommands do


  it "should parse custom command" do
    assert_custom_command('slide up', :custom, {:action => :custom, :custom_action => 'slide', :target => 'up'})
  end

  def assert_custom_command(user_input, command, options)
    CustomCommands.new(user_input).send(command).should == options
  end

  end