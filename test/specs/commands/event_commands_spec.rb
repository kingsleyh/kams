require File.dirname(__FILE__) + '/../../../components/manager'
require File.dirname(__FILE__) + '/../../../objects/player'
require File.dirname(__FILE__) + '/../../../components/commands/event_commands'
require 'eventmachine'


describe EventCommands do

  before(:each) do
    EventMachine = mock(EventMachine)
    $manager = Manager.new
    @player = Player.new(self, nil, ServerConfig.start_room, "superman", [], "a typical person", "This is a normal, everyday kind of person.", "person", "f")
  end

  it "should parse alarm" do
    EventMachine.should_receive(:add_timer).with(3)
    EventCommands.new('alarm 3', @player).send(:alarm)
  end

  it "should parse alarm with message" do
    EventMachine.should_receive(:add_timer).with(180)
    EventCommands.new('alarm 3 min this is cool', @player).send(:alarm_with_message)
  end

  it "should return correct command list" do
    EventCommands.all_commands.should == Set.new(%w(alarm))
  end

  it "should find all commands in the command list" do
    EventCommands.all_commands.each do |command|
      EventCommands.has_this?(command).should == true
    end
  end

  it "should not find a command that is not in the command list" do
    EventCommands.has_this?('command_not_present').should == false
  end


end