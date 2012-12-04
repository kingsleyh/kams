require 'net/telnet'
require 'ansi/code'
require File.dirname(__FILE__) + '/test_data_generator'

class FailedAssertion < Exception
end

class AutoMud

  def connect
    @c = Net::Telnet.new("Host" => "localhost","Port" => 8888,"Timeout" => 1)
    wait_for(/\n/)
  end

  def login(character)
    connect
    cmd("1",/Character name:/)
    cmd(character.name,/Password/)
    cmd(character.password,/.+/)
  end

  def logout
    cmd("quit",/.+/)
  end

  def create_character(character)
    choose_to_create_new_character
    choose_name(character.name)
    choose_gender(character.gender)
    choose_password(character.password)
    enable_colour?(character.use_ansi_colour)
  end

  def choose_to_create_new_character
    connect
    cmd("2",/Desired character name/)
  end

  def choose_name(name)
    cmd(name,/Sex/)
  end

  def choose_gender(gender)
    cmd(gender,/Enter password/)
  end

  def choose_password(password)
    cmd(password,/Use color/)
  end

  def enable_colour?(choice)
   cmd(choice,/.+/)
  end

  def user_is_logged_in?(name)
    cmd("who",/#{name.capitalize}/)
  end

  def delete_current_character(character)
    cmd("delete me please",/To confirm your deletion, please enter your password/)
    cmd(character.password,/This character #{character.name.capitalize} will no longer exist/)
  end

  private
  def wait_for(regex)
    @c.waitfor(regex){|line| puts line}
  end

  def cmd(command,regex)
    begin
    transcript = ""
    @c.cmd("String" => command, "Match" => regex){|result| puts result ; transcript << result}
    rescue Timeout::Error => e
     raise FailedAssertion.new("Expected: #{regex.to_s} but got: #{display(transcript)}")
    end
  end

  def display(transcript)
    ANSI.unansi(transcript)
  end


end

