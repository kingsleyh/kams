require File.dirname(__FILE__) + '/commands'

class CommunicationCommands < Commands

  def self.has_this?(command)
    all_commands.include?(command)
  end

  def self.all_commands
    Set.new(%w(say sayto whisper tell reply))
  end

  def self.category
    :Communication
  end

  def say
    condition(/^say\s+(\((?<pre>.*?)\)\s*)?(?<phrase>.*)$/i) do |with|
      {:action => :say, :phrase => with[:phrase], :pre => with[:pre]} unless with.nil?
    end
  end

  def sayto
    condition(/^sayto\s+(?<target>\w+)\s+(\((?<pre>.*?)\)\s*)?(?<phrase>.*)$/i) do |with|
      {:action => :say, :target => with[:target], :phrase => with[:phrase], :pre => with[:pre]} unless with.nil?
    end
  end

  def whisper
    condition(/^whisper\s+(?<to>\w+)\s+(\((?<pre>.*?)\)\s*)?(?<phrase>.*)$/i) do |with|
      {:action => :whisper, :to => with[:to], :phrase => with[:phrase], :pre => with[:pre]} unless with.nil?
    end
  end

  def tell
    condition(/^tell\s+(?<target>\w+)\s+(?<message>.*)$/i) do |with|
      {:action => :tell, :target => with[:target], :message => with[:message]} unless with.nil?
    end
  end

  def reply
    condition(/^reply\s+(?<message>.*)$/i) do |with|
      {:action => :reply, :message => with[:message]} unless with.nil?
    end
  end


end