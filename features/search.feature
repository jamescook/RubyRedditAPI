Feature: Searching
  I want to be able to search submissions

  Scenario: Valid subreddit
    Given I search 'test' with 'test'
    Then I should get back search results
