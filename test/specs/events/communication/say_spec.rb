require File.dirname(__FILE__) + '/../../../../events/communication/say'
require File.dirname(__FILE__) + '/../../../../lib/event'

describe Communication do

  it "should return correct response for say with no target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello', :pre => nil, :target => nil})
      player = double(:player)
      room = double(:room)

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello',
                            :pre => nil,
                            :type => :Communication,
                            :target => nil,
                            :to_player => 'you say, <say>"Hello."</say>',
                            :to_other => 'superman says, <say>"Hello."</say>',
                            :to_blind_other => 'Someone says, <say>"Hello."</say>',
                            :to_deaf_target => 'You see superman say something.',
                            :to_deaf_other => 'You see superman say something.')

      player.should_receive(:name).exactly(3).times.and_return("superman")
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with pre with no target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello', :pre => 'sarcastically', :target => nil})
      player = double(:player)
      room = double(:room)

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello',
                            :pre => 'sarcastically, ',
                            :type => :Communication,
                            :target => nil,
                            :to_player => 'sarcastically, you say, <say>"Hello."</say>',
                            :to_other => 'sarcastically, superman says, <say>"Hello."</say>',
                            :to_blind_other => 'Someone says, <say>"Hello."</say>',
                            :to_deaf_target => 'You see superman say something.',
                            :to_deaf_other => 'You see superman say something.')

      player.should_receive(:name).exactly(3).times.and_return("superman")
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with no phrase and no target" do
      event = Event.new(:Communication, {:action => :say, :phrase => nil, :pre => nil, :target => nil})
      player = double(:player)
      room = double(:room)
      player.should_receive(:output).with('Huh?')
      Communication.say(event, player, room)
    end

    it "should return correct response for say with self as target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'Hello', :pre => nil, :target => 'superman'})
      player = double(:player)
      room = double(:room)
      room.should_receive(:find).with('superman').and_return(player)
      player.should_receive(:output).with('Talking to yourself again?')
      Communication.say(event, player, room)
    end

    it "should return correct response for say with emoticon smile :) with no target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello :)', :pre => nil, :target => nil})
      player = double(:player)
      room = double(:room)

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello :)',
                            :pre => nil,
                            :type => :Communication,
                            :target => nil,
                            :to_player => 'you smile and say, <say>"Hello."</say>',
                            :to_other => 'superman smiles and says, <say>"Hello."</say>',
                            :to_blind_other => 'Someone smiles and says, <say>"Hello."</say>',
                            :to_deaf_target => 'You see superman say something.',
                            :to_deaf_other => 'You see superman say something.')

      player.should_receive(:name).exactly(3).times.and_return("superman")
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with emoticon laugh :D with no target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello :D', :pre => nil, :target => nil})
      player = double(:player)
      room = double(:room)

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello :D',
                            :pre => nil,
                            :type => :Communication,
                            :target => nil,
                            :to_player => 'you laugh as you say, <say>"Hello."</say>',
                            :to_other => 'superman laughs as he says, <say>"Hello."</say>',
                            :to_blind_other => 'Someone laughs as he says, <say>"Hello."</say>',
                            :to_deaf_target => 'You see superman say something.',
                            :to_deaf_other => 'You see superman say something.')

      player.should_receive(:name).exactly(3).times.and_return("superman")
      player.should_receive(:pronoun).and_return("he")
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with emoticon frown :( with no target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello :(', :pre => nil, :target => nil})
      player = double(:player)
      room = double(:room)

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello :(',
                            :pre => nil,
                            :type => :Communication,
                            :target => nil,
                            :to_player => 'you frown and say, <say>"Hello."</say>',
                            :to_other => 'superman frowns and says, <say>"Hello."</say>',
                            :to_blind_other => 'Someone frowns and says, <say>"Hello."</say>',
                            :to_deaf_target => 'You see superman say something.',
                            :to_deaf_other => 'You see superman say something.')

      player.should_receive(:name).exactly(3).times.and_return("superman")
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with emoticon smile :) with target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello :)', :pre => nil, :target => 'spiderman'})
      player = double(:player)
      room = double(:room)
      target_player = double(:target_player, :name => 'spiderman')

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello :)',
                            :pre => nil,
                            :target => target_player,
                            :type => :Communication,
                            :to_target => 'superman smiles and says to you, <say>"Hello."</say>',
                            :to_player => 'you smile and say to spiderman, <say>"Hello."</say>',
                            :to_other => 'superman smiles and says to spiderman, <say>"Hello."</say>',
                            :to_blind_target => 'Someone smiles and says, <say>"Hello."</say>',
                            :to_blind_other => 'Someone smiles and says, <say>"Hello."</say>',
                            :to_deaf_target => 'You see superman say something to you.',
                            :to_deaf_other => 'You see superman say something to spiderman.')

      player.should_receive(:name).exactly(4).times.and_return('superman')
      room.should_receive(:find).with('spiderman').and_return(target_player)
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with emoticon laugh :D with target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello :D', :pre => nil, :target => 'spiderman'})
      player = double(:player)
      room = double(:room)
      target_player = double(:target_player, :name => 'spiderman')

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello :D',
                            :pre => nil,
                            :target => target_player,
                            :type => :Communication,
                            :to_target => 'superman laughs as he says to you, <say>"Hello."</say>',
                            :to_player => 'you laugh as you say to spiderman, <say>"Hello."</say>',
                            :to_other => 'superman laughs as he says to spiderman, <say>"Hello."</say>',
                            :to_blind_target => 'Someone laughs as he says, <say>"Hello."</say>',
                            :to_blind_other => 'Someone laughs as he says, <say>"Hello."</say>',
                            :to_deaf_target => 'You see superman say something to you.',
                            :to_deaf_other => 'You see superman say something to spiderman.')

      player.should_receive(:pronoun).and_return('he')
      player.should_receive(:name).exactly(4).times.and_return('superman')
      room.should_receive(:find).with('spiderman').and_return(target_player)
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with emoticon frown :( with target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello :(', :pre => nil, :target => 'spiderman'})
      player = double(:player)
      room = double(:room)
      target_player = double(:target_player, :name => 'spiderman')

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello :(',
                            :pre => nil,
                            :type => :Communication,
                            :target => target_player,
                            :to_target => 'superman frowns and says to you, <say>"Hello."</say>',
                            :to_player => 'you frown and say to spiderman, <say>"Hello."</say>',
                            :to_other => 'superman frowns and says to spiderman, <say>"Hello."</say>',
                            :to_blind_target => 'Someone frowns and says, <say>"Hello."</say>',
                            :to_blind_other => 'Someone frowns and says, <say>"Hello."</say>',
                            :to_deaf_target => 'You see superman say something to you.',
                            :to_deaf_other => 'You see superman say something to spiderman.')

      player.should_receive(:name).exactly(4).times.and_return('superman')
      room.should_receive(:find).with('spiderman').and_return(target_player)
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with emoticon frown :( with target and pre" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello :(', :pre => 'slowly', :target => 'spiderman'})
      player = double(:player)
      room = double(:room)
      target_player = double(:target_player, :name => 'spiderman')

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello :(',
                            :pre => 'slowly, ',
                            :target => target_player,
                            :type => :Communication,
                            :to_target => 'slowly, superman frowns and says to you, <say>"Hello."</say>',
                            :to_player => 'slowly, you frown and say to spiderman, <say>"Hello."</say>',
                            :to_other => 'slowly, superman frowns and says to spiderman, <say>"Hello."</say>',
                            :to_blind_target => 'Someone frowns and says, <say>"Hello."</say>',
                            :to_blind_other => 'Someone frowns and says, <say>"Hello."</say>',
                            :to_deaf_target => 'You see superman say something to you.',
                            :to_deaf_other => 'You see superman say something to spiderman.')

      player.should_receive(:name).exactly(4).times.and_return('superman')
      room.should_receive(:find).with('spiderman').and_return(target_player)
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with exclaim and no target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello!', :pre => nil, :target => nil})
      player = double(:player)
      room = double(:room)

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello!',
                            :pre => nil,
                            :type => :Communication,
                            :target => nil,
                            :to_player => 'you exclaim, <say>"Hello!"</say>',
                            :to_other => 'superman exclaims, <say>"Hello!"</say>',
                            :to_blind_other => 'Someone exclaims, <say>"Hello!"</say>',
                            :to_deaf_target => 'You see superman say something.',
                            :to_deaf_other => 'You see superman say something.')

      player.should_receive(:name).exactly(3).times.and_return("superman")
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with question and no target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello?', :pre => nil, :target => nil})
      player = double(:player)
      room = double(:room)

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello?',
                            :pre => nil,
                            :type => :Communication,
                            :target => nil,
                            :to_player => 'you ask, <say>"Hello?"</say>',
                            :to_other => 'superman asks, <say>"Hello?"</say>',
                            :to_blind_other => 'Someone asks, <say>"Hello?"</say>',
                            :to_deaf_target => 'You see superman say something.',
                            :to_deaf_other => 'You see superman say something.')

      player.should_receive(:name).exactly(3).times.and_return("superman")
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with no punctuation at end and no target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello', :pre => nil, :target => nil})
      player = double(:player)
      room = double(:room)

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello',
                            :pre => nil,
                            :type => :Communication,
                            :target => nil,
                            :to_player => 'you say, <say>"Hello."</say>',
                            :to_other => 'superman says, <say>"Hello."</say>',
                            :to_blind_other => 'Someone says, <say>"Hello."</say>',
                            :to_deaf_target => 'You see superman say something.',
                            :to_deaf_other => 'You see superman say something.')

      player.should_receive(:name).exactly(3).times.and_return("superman")
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with exclaim with target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello!', :pre => nil, :target => 'spiderman'})
      player = double(:player)
      room = double(:room)
      target_player = double(:target_player, :name => 'spiderman')

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello!',
                            :pre => nil,
                            :type => :Communication,
                            :target => target_player,
                            :to_target => 'superman exclaims to you, <say>"Hello!"</say>',
                            :to_player => 'you exclaim to spiderman, <say>"Hello!"</say>',
                            :to_other => 'superman exclaims to spiderman, <say>"Hello!"</say>',
                            :to_blind_target => 'Someone exclaims, <say>"Hello!"</say>',
                            :to_blind_other => 'Someone exclaims, <say>"Hello!"</say>',
                            :to_deaf_target => 'You see superman say something to you.',
                            :to_deaf_other => 'You see superman say something to spiderman.')

      player.should_receive(:name).exactly(4).times.and_return("superman")
      room.should_receive(:find).with('spiderman').and_return(target_player)
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with question with target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello?', :pre => nil, :target => 'spiderman'})
      player = double(:player)
      room = double(:room)
      target_player = double(:target_player, :name => 'spiderman')

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello?',
                            :pre => nil,
                            :type => :Communication,
                            :target => target_player,
                            :to_target => 'superman asks you, <say>"Hello?"</say>',
                            :to_player => 'you ask spiderman, <say>"Hello?"</say>',
                            :to_other => 'superman asks spiderman, <say>"Hello?"</say>',
                            :to_blind_target => 'Someone asks, <say>"Hello?"</say>',
                            :to_blind_other => 'Someone asks, <say>"Hello?"</say>',
                            :to_deaf_target => 'superman seems to be asking you something.',
                            :to_deaf_other => 'superman seems to be asking spiderman something.')

      player.should_receive(:name).exactly(4).times.and_return("superman")
      room.should_receive(:find).with('spiderman').and_return(target_player)
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

    it "should return correct response for say with no punctuation at end with target" do
      event = Event.new(:Communication, {:action => :say, :phrase => 'hello', :pre => nil, :target => 'spiderman'})
      player = double(:player)
      room = double(:room)
      target_player = double(:target_player, :name => 'spiderman')

      out_event = Event.new(:Communication,
                            :action => :say,
                            :phrase => 'Hello',
                            :pre => nil,
                            :type => :Communication,
                            :target => target_player,
                            :to_target => 'superman says to you, <say>"Hello."</say>',
                            :to_player => 'you say to spiderman, <say>"Hello."</say>',
                            :to_other => 'superman says to spiderman, <say>"Hello."</say>',
                            :to_blind_target => 'Someone says, <say>"Hello."</say>',
                            :to_blind_other => 'Someone says, <say>"Hello."</say>',
                            :to_deaf_target => 'You see superman say something to you.',
                            :to_deaf_other => 'You see superman say something to spiderman.')

      player.should_receive(:name).exactly(4).times.and_return("superman")
      room.should_receive(:find).with('spiderman').and_return(target_player)
      room.should_receive(:out_event).with(out_event)
      Communication.say(event, player, room)
    end

end