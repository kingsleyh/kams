require File.dirname(__FILE__) + '/../../../components/commands/communication_commands'

describe CommunicationCommands do

  it "should return correct category" do
    CommunicationCommands.category.should == :Communication
  end

  it "should return correct command list" do
    CommunicationCommands.all_commands.should == Set.new(%w(say sayto whisper tell reply))
  end

  it "should find all commands in the command list" do
    CommunicationCommands.all_commands.each do |command|
      CommunicationCommands.has_this?(command).should == true
    end
  end

  it "should not find a command that is not in the command list" do
    CommunicationCommands.has_this?('command_not_present').should == false
  end

  it "should parse say" do
    assert_communication_command('say (with interest) hello', :say, {:action => :say, :phrase => 'hello', :pre => 'with interest'})
    assert_communication_command('say hello', :say, {:action => :say, :phrase => 'hello', :pre => nil})
  end

  it "should parse sayto" do
    assert_communication_command('sayto maggie hello', :sayto, {:action => :say, :phrase => 'hello', :pre => nil, :target => 'maggie'})
    assert_communication_command('sayto maggie (with pride) hello', :sayto, {:action => :say, :phrase => 'hello', :pre => 'with pride', :target => 'maggie'})
  end

  it "should parse whisper" do
    assert_communication_command('whisper maggie (with interest) hello', :whisper, {:action => :whisper, :phrase => 'hello', :pre => 'with interest', :to => 'maggie'})
    assert_communication_command('whisper maggie hello', :whisper, {:action => :whisper, :phrase => 'hello', :pre => nil, :to => 'maggie'})
  end

  it "should parse tell" do
    assert_communication_command('tell maggie hello', :tell, {:action => :tell, :message => 'hello', :target => 'maggie'})
  end

  it "should parse reply" do
    assert_communication_command('reply hello', :reply, {:action => :reply, :message => 'hello'})
  end

  def assert_communication_command(user_input, command, options)
    CommunicationCommands.new(user_input).send(command).should == options
  end


end