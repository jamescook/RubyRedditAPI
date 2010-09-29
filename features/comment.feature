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
