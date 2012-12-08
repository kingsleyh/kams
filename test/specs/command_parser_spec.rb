require File.dirname(__FILE__) + '/../../components/manager'
require File.dirname(__FILE__) + '/../../components/command_parser'
require File.dirname(__FILE__) + '/../../objects/player'
require 'eventmachine'

describe CommandParser do

  before(:each) do
    EventMachine = mock(EventMachine)
    $LOG ||= Logger.new
    $manager = Manager.new
    @player = Player.new(self, nil, ServerConfig.start_room, "superman", [], "a typical person", "This is a normal, everyday kind of person.", "person", "f")
  end

  it "should parse a future event" do
    event = CommandParser.future_event(@player, 3)
    assert_future_event(event, 3, :event, nil)
  end

  it "should parse a future event with existing event" do
    existing_event = CommandParser.parse(@player, 'look man')
    event = CommandParser.future_event(@player, 3, existing_event)
    assert_future_event(event, 3, :event, existing_event)
  end

  it "should parse a future event with supplied block" do
    new_event = CommandParser.parse(@player, 'look man')
    event_proc = Proc.new { new_event }
    event = CommandParser.future_event(@player, 3) do
      new_event
    end
    assert_future_event(event, 3, :call, event_proc)
  end

  it "should parse a generic command" do
    assert_event('look man', :Generic)
  end

  it "should parse a communication command" do
    assert_event('say hi', :Communication)
  end

  it "should parse a movement command" do
    assert_event('go east', :Movement)
  end

  it "should parse an emote command" do
    assert_event('emote smiles', :Emote)
  end

  it "should parse an equipment command" do
    assert_event('wear helmet', :Clothing)
  end

  it "should parse a weapon combat command" do
    assert_event('slash', :WeaponCombat)
  end

  it "should parse a martial combat command" do
    assert_event('kick man', :MartialCombat)
  end

  it "should parse a news command" do
    assert_event('news read 1', :News)
  end

  it "should parse an admin command" do
    @player.enable_admin
    assert_event('awho', :Admin)
  end

  it "should parse an future command" do
    EventMachine.should_receive(:add_timer).with(3)
    assert_event('alarm 3', :Future)
  end

  it "should parse a custom command" do
    assert_event('this is custom', :Custom)
  end


  def assert_event(user_input, event_type)
    event = CommandParser.parse(@player, user_input)
    event.type.should == event_type
    event.player.should == @player
  end

  def assert_future_event(event, time, action, supplied_event)
    event.type.should == :Future
    event.time.should == time
    event.action.should == action
    event.player.should == @player
    event.event.should == supplied_event
  end

end
