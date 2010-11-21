Feature: Message Group
  I want to be able to mark multiple messages as read or unread

  Scenario: Mark multiple messages read
    Given I am logged in
    And I have unread messages
    When I mark all unread messages read
    Then I should have no unread messages

  Scenario: Mark multiple messages unread
    Given I am logged in
    And I have unread messages
    When I mark all read messages unread
    Then I should have no read messages
