require File.dirname(__FILE__) + '/commands'

class NewsCommands < Commands

  def self.has_this?(command)
    all_commands.include?(command)
  end

  def self.all_commands
    Set.new(%w(punch kick dodge))
  end

  def self.category
    :News
  end

  def latest_news
    condition(/^news\s+last\s+(?<limit>\d+)/i) do |with|
      {:action => :latest_news, :limit => with[:limit].to_i} unless with.nil?
      end
  end

  def news
    condition(/^news$/i) do |with|
      {:action => :latest_news} unless with.nil?
      end
  end

  def read_post
    condition(/^news\s+(read\s+)?(?<post_id>\d+)$/i) do |with|
      {:action => :read_post, :post_id => with[:post_id]} unless with.nil?
      end
  end

  def write_post
    condition(/^news\s+write$/i) do |with|
      {:action => :write_post} unless with.nil?
      end
  end

  def reply_post
    condition(/^news\s+reply(\s+to\s+)?\s+(?<reply_to>\d+)$/i) do |with|
      {:action => :write_post, :reply_to => with[:reply_to]} unless with.nil?
      end
  end

  def delete_post
    condition(/^news\s+delete\s+(?<post_id>\d+)/i) do |with|
      {:action => :delete_post, :post_id => with[:post_id]} unless with.nil?
      end
  end

  def list_unread
    condition(/^news\s+unread/i) do |with|
      {:action => :list_unread} unless with.nil?
      end
  end

  def news_all
    condition(/^news\s+all/i) do |with|
      {:action => :all} unless with.nil?
      end
  end

end
