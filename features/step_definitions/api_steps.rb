Given /^I submit a valid subreddit$/ do
  Reddit::Api.base_uri "reddit.local"
  @api = Reddit::Api.new "reddit", "password"
  @subreddit = "reddit_test0"
end

Then /^I should get back a listing of submissions$/ do
  results = @api.browse(@subreddit)
  results[0].class.should == Reddit::Submission
  results[0].author.should_not == nil
end

Given /^I submit a invalid subreddit$/ do
  Reddit::Api.base_uri "reddit.local"
  @api = Reddit::Api.new "reddit", "password"
  @subreddit = "invalid_subreddit"
end

Then /^I should get back some error$/ do
  results = @api.browse(@subreddit)
  results.should == false
end
