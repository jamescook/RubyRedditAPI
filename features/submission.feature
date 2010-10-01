Feature: Submissions
  I want to be able to peruse the submission details
  And I want to be able to up vote the submission
  And I want to be able to down vote the submission
  And I want to be able to save submissions I like
  And I want to be able to unsave submissions


  Scenario: Viewing a submission
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
      But I should not be able to save the submission
      But I should not be able to unsave the submission
      But I should not be able to hide the submission
      But I should not be able to unhide the submission
      But I should not be able to report the submission
      And I should be able to see more comments if needed

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
      And I should be able to save the submission
      And I should be able to unsave the submission
      And I should be able to hide the submission
      And I should be able to unhide the submission
      And I should be able to report the submission
      And I should be able to see more comments if needed
