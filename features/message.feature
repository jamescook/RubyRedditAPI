Feature: Messaging

  Scenario: I want to be able to read my sent messages
    Given I am logged in
    When I go to the sent messages page
    Then I should see a listing of messages

  Scenario: I want to change message read status
    Given I am logged in
    And I have received messages
    When I go to the received messages page
    Then I should be able to mark them as unread
    And I should be able to mark them as read

  Scenario: I want to be able to read my unread messages
    Given I am logged in
    And I have unread messages
    When I go to the unread messages page
    Then I should see a listing of messages
