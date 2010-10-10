Given /^I search '([^']+)' with '([^']+)'$/ do |subreddit, terms|
  # FIXME searching isnt working for me by default in the reddit vm
  Reddit::Base.base_uri "reddit.com"
  Reddit::Api.base_uri "reddit.com"
  @api       = Reddit::Api.new
  @subreddit = subreddit
  @terms     = terms
end

Then /^I should get back search results$/ do
  results = @api.search(@terms, :in => @subreddit)
  results[0].class.should == Reddit::Submission
end
