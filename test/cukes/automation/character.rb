require File.dirname(__FILE__) + '/test_data_generator'
require File.dirname(__FILE__) + '/../../../util/log_file'

class Character

  attr_reader :name, :password

  def initialize(name, password, gender, use_ansi_colour)
    @name = name
    @password = password
    @gender = gender
    @use_ansi_colour = use_ansi_colour
  end

  def gender
    @gender == :female ? "F" : "M"
  end

  def use_ansi_colour
    @use_ansi_colour == :yes ? "y" : "n"
  end

  def self.random_character
    character = Character.new(TestDataGenerator.random_string(6), TestDataGenerator.random_string(6), :female, :yes)
    LogFile.log.info("Creating new random character with: \nname: #{character.name} \npassword: #{character.password} \ngender: #{character.gender} \nansi: #{character.use_ansi_colour}")
    character
  end

end