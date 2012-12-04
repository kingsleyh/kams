require File.dirname(__FILE__) + '/../lib/game_object'

class Weapon < GameObject
  include Wearable

  def initialize(*args)
    super
    info.position = :wield
    info.weapon_type = nil
    info.attack = 0
    info.defense = 0
    info.layer = 0
    @movable = true
    @generic = "weapon"
  end
end
