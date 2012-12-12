require File.dirname(__FILE__) + '/../../../../events/communication'
require File.dirname(__FILE__) + '/../../../../lib/event'

describe Communication do

  it "should return correct response for whisper with no target" do
    event = Event.new(:Communication, {:action => :whisper, :phrase => 'hello', :pre => nil, :to => nil})
    player = double(:player)
    room = double(:room)
    room.should_receive(:find).with(nil, Player).and_return(nil)
    player.should_receive(:output).with("To whom are you trying to whisper?")
    Communication.whisper(event, player, room)
  end

  it "should return correct response for whisper with self as target" do
    event = Event.new(:Communication, {:action => :whisper, :phrase => 'hello', :pre => nil, :to => 'superman'})
    player = double(:player)
    room = double(:room)

    out_event = Event.new(:Communication,
                          :action => :whisper,
                          :phrase => 'hello',
                          :pre => nil,
                          :type => :Communication,
                          :to => 'superman',
                          :to_other => 'superman whispers to himself.')

    room.should_receive(:find).with('superman', Player).and_return(player)
    player.should_receive(:name).and_return('superman')
    player.should_receive(:pronoun).with(:reflexive).and_return('himself')
    player.should_receive(:output).with("Whispering to yourself again?")
    room.should_receive(:out_event).with(out_event, player)
    Communication.whisper(event, player, room)
  end

  it "should return correct response for whisper with no phrase" do
    event = Event.new(:Communication, {:action => :whisper, :phrase => nil, :pre => nil, :to => 'spiderman'})
    player = double(:player)
    room = double(:room)
    target_player = double(:target_player, :name => 'spiderman')
    room.should_receive(:find).with('spiderman', Player).and_return(target_player)
    player.should_receive(:output).with("What are you trying to whisper?")
    Communication.whisper(event, player, room)
  end

  it "should return correct response for whisper with a target" do
    event = Event.new(:Communication, {:action => :whisper, :phrase => 'hello', :pre => nil, :to => 'spiderman'})
    player = double(:player)
    room = double(:room)
    target_player = double(:target_player, :name => 'spiderman')

    out_event = Event.new(:Communication,
                          :action => :whisper,
                          :phrase => 'Hello',
                          :pre => nil,
                          :type => :Communication,
                          :to => 'spiderman',
                          :target => target_player,
                          :to_player => "you whisper to spiderman, <say>\"Hello.\"</say>",
                          :to_target => "superman whispers to you, <say>\"Hello.\"</say>",
                          :to_other => "superman whispers quietly into spiderman's ear.",
                          :to_other_blind => "superman whispers.",
                          :to_target_blind => "Someone whispers to you, <say>\"Hello.\"</say>")

    room.should_receive(:find).with('spiderman', Player).and_return(target_player)
    player.should_receive(:name).exactly(3).times.and_return("superman")
    room.should_receive(:out_event).with(out_event)
    Communication.whisper(event, player, room)
  end

end