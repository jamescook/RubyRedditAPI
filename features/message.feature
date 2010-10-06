Feature: Messaging
  Scenario: I want to be able to read my sent messages
    Given I am logged in
    When I go to the sent messages page
    Then I should see a listing of messages
