Feature: Comments
  I want to be able to comment on a comment
  I want to be able to delete my comments

  Scenario: Valid comment text
    Given I enter some text
    Then I should be able to add a comment

  Scenario: I want to hide a comment
    Given I have a comment
    Then I should be able to hide the comment

  Scenario: I want to remove a comment
    Given I have a comment
    Then I should be able to remove the comment

  Scenario: I want to approve a comment
    Given I have a comment
    Then I should be able to approve the comment

  Scenario: I want to edit a comment
    Given I have a comment
    Then I should be able to edit the comment

  Scenario: I want to comment on a comment
    Given I have a comment
    Then I should be able to reply to the comment

  Scenario: I want to moderator distinguish a comment
    Given I have a comment
    Then I should be able to moderator distinguish the comment

  Scenario: I want to indistinguish a comment
    Given I have a comment
    Then I should be able to indistinguish the comment

  Scenario: I want to admin distinguish a comment
    Given I have a comment
    Then I should be able to admin distinguish the comment

