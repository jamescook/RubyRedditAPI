Feature: Viewing a submission
  I want to be able to peruse the submission details
  And I want to be able to up vote the submission
  And I want to be able to down vote the submission

  Scenario: When not logged in
    Given I have a submission
    And I'm not logged in
    Then I should be able to see the author
    And I should be able to see the title
    And I should be able to see the selftext
    And I should be able to see the url
    And I should be able to see the up votes
    And I should be able to see the down votes
    And I should be able to see the comments
    But I should not be able to upvote it
    But I should not be able to downvote it

  Scenario: When logged in
    Given I have a submission
    And I'm logged in
    Then I should be able to see the author
    And I should be able to see the title
    And I should be able to see the selftext
    And I should be able to see the url
    And I should be able to see the up votes
    And I should be able to see the down votes
    And I should be able to see the comments
    And I should be able to upvote it
    And I should be able to downvote it
