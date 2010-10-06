@user
Feature: User
  In order have friends
  As a Redditor
  I want to be able to add and remove them

  Scenario: Valid user and password
    Given I select a redditor
    Then I should be able to friend them
    And I should be able to unfriend them

