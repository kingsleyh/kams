require File.dirname(__FILE__) + '/commands'

class CustomCommands < Commands

  def custom
    condition(/^(?<custom_action>\w+)\s+(?<target>.*)$/) do |with|
      {:action => :custom, :custom_action => with[:custom_action], :target => with[:target]} unless with.nil?
      end
  end

end
