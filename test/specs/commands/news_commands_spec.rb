require File.dirname(__FILE__) + '/../../../components/commands/news_commands'

describe NewsCommands do

  it "it should parse latest news" do
    assert_news_command('news last 2', :latest_news, {:action => :latest_news, :limit => 2})
  end

  it "should parse news" do
    assert_news_command('news', :news, {:action => :latest_news})
  end

  it "should parse read post" do
    assert_news_command('news read 1', :read_post, {:action => :read_post, :post_id => "1"})
    assert_news_command('news 1', :read_post, {:action => :read_post, :post_id => "1"})
  end

  it "should parse write post" do
    assert_news_command('news write', :write_post, {:action => :write_post})
  end

  it "should parse reply post" do
    assert_news_command('news reply 1', :reply_post, {:action => :write_post, :reply_to => "1"})
  end

  it "should parse delete post" do
    assert_news_command('news delete 1', :delete_post, {:action => :delete_post, :post_id => "1"})
  end

  it "should parse list unread" do
    assert_news_command('news unread', :list_unread, {:action => :list_unread})
  end

  it "should parse news all" do
    assert_news_command('news all', :news_all, {:action => :all})
  end

  def assert_news_command(user_input, command, options)
    NewsCommands.new(user_input).send(command).should == options
  end

end