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

  end

  def news

  end

  def read_post

  end

  def write_post

  end

  def reply_post

  end

  def delete_post

  end

  def list_unread

  end

end








#case input.downcase
#       when "news"
#         event.action = :latest_news
#       when /^news\s+last\s+(\d+)/i
#         event.action = :latest_news
#         event.limit = $1.to_i
#       when /^news\s+(read\s+)?(\d+)$/i
#         event.action = :read_post
#         event.post_id = $2
#       when /^news\s+write$/i
#         event.action = :write_post
#       when /^news\s+reply(\s+to\s+)?\s+(\d+)$/i
#         event.action = :write_post
#         event.reply_to = $2
#       when /^news\s+delete\s+(\d+)/i
#         event.action = :delete_post
#         event.post_id = $1
#       when /^news\s+unread/i
#         event.action = :list_unread
#       when /^news\s+all/i
#         event.action = :all
#       else