require File.dirname(__FILE__) + '/../../../components/commands/emotes_commands'

describe EmotesCommands do

  it "should return correct category" do
    EmotesCommands.category.should == :Emote
  end

  it "should return correct command list" do
    EmotesCommands.all_commands.should == Set.new(%w(smile cheer back laugh cry emote eh er eh? uh pet hug blush ew frown grin hm snicker wave poke yes no huh hi bye yawn bow curtsey brb agree sigh ponder shrug skip nod))
  end

  it "should find all commands in the command list" do
    EmotesCommands.all_commands.each do |command|
      EmotesCommands.has_this?(command).should == true
    end
  end

  it "should not find a command that is not in the command list" do
    EmotesCommands.has_this?('command_not_present').should == false
  end

  it "it should parse emote" do
    assert_emote_command('emote sings happily', :emote, {:action => :emote, :show => 'sings happily'})
  end

  it "should parse emote predefined" do
    assert_predefined_emote %w(uh er eh? eh shrug sigh ponder agree cry hug pet smile laugh ew blush grin frown snicker wave poke yes no huh hi bye yawn bow curtsey brb skip nod back cheer hm)
  end

  def assert_emote_command(user_input, command, options)
    EmotesCommands.new(user_input).send(command).should == options
  end

  def assert_predefined_emote(commands)
    commands.each do |command|
      assert_emote_command(command, :emote_predefined, {:action => command.to_sym, :object => nil, :post => nil})
      assert_emote_command(command + ' maggie', :emote_predefined, {:action => command.to_sym, :object => 'maggie', :post => nil})
      assert_emote_command(command + ' maggie (loudly)', :emote_predefined, {:action => command.to_sym, :object => 'maggie', :post => 'loudly'})
    end
  end
end

