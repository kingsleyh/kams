require 'andand'

class Commands

  def initialize(user_input)
    @user_input = user_input
  end

  def condition(expression)
    yield @user_input.match(expression)
  end

end