Feature: Authentication
  In order perform things like voting and commenting
  As a Redditor
  I want to be able to login in my step definitions

  Scenario: Valid user and password
    Given I have a valid user
    And I send my user and password to the login API
    Then I should have a valid cookie
    And the stored headers should refer to the cookie

  Scenario: Invalid user and password
    Given I have a invalid user
    And I send my user and password to the login API
    Then I should not have a valid cookie
