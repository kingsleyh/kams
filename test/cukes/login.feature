Feature: Login
  As a player
  I want to login to the mud
  So that I can play

  Scenario: Create a new character
    When I create a new character
    Then I should be asked for the character name
    And the gender
    And a password
    And if I want to use ansi colour
    And I should be logged in with my character

  Scenario: Login with existing character
    Given I have an existing character
    When I login
    Then I should be logged in with my character
