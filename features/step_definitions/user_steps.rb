Before do
  load_server_config
  Reddit::Base.base_uri @address
  Reddit::Api.base_uri @address
  Reddit::Thing.base_uri @address
  Reddit::Submission.base_uri @address
  Reddit::Comment.base_uri @address
  Reddit::User.base_uri @address
  @api = Reddit::Api.new @user, @pass
  @api.login
end

Given /^I select a redditor$/ do
  @submission = @api.browse("reddit_test1")[0]
  @user = @submission.author
end

Then /^I should be able to friend them$/ do
  @user.friend.should be true
end

Then /^I should be able to unfriend them$/ do
  @user.unfriend.should be true
end



