Feature: Browsing
  I want to be able to browse submissions

  Scenario: Valid subreddit
    Given I submit a valid subreddit
    Then I should get back a listing of submissions

  Scenario: Invalid subreddit
    Given I submit a invalid subreddit
    Then I should get back some error
