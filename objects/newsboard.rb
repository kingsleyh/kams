require File.dirname(__FILE__) + '/../lib/game_object'
require File.dirname(__FILE__) + '/../traits/news'

#Newsboards for posting news.
#
#===Info
# board_name (String)
# announce_new (String)
class Newsboard < GameObject
  include News

  def initialize(*args)
    super
    @name = 'newsboard'
    @generic = 'newsboard'
    @alt_names = ['board', 'bulletin board', 'notice board', 'messageboard']
    @movable = false
    @info.board_name = "A Nice Board"
    @info.announce_new = "An excited voice shouts, \"Someone wrote a new post!\""
  end
end
