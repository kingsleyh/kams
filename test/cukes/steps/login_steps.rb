require File.dirname(__FILE__) + '/../automation/auto_mud'
require File.dirname(__FILE__) + '/../automation/character'

Before do
  @auto = AutoMud.new
  @auto.connect
  @character = Character.random_character
end

After do
  @auto.delete_current_character(@character)
end

When /^I create a new character$/ do
 @auto.choose_to_create_new_character
end

Then /^I should be asked for the character name$/ do
  @auto.choose_name(@character.name)
end

Then /^the gender$/ do
 @auto.choose_gender(@character.gender)
end

Then /^a password$/ do
 @auto.choose_password(@character.password)
end

Then /^if I want to use ansi colour$/ do
  @auto.enable_colour?(@character.use_ansi_colour)
end

Then /^I should be logged in with my character$/ do
  @auto.user_is_logged_in?(@character.name)
end

Given /^I have an existing character$/ do
  @auto.create_character(@character)
  @auto.logout
end

When /^I login$/ do
  @auto.login(@character)
end

