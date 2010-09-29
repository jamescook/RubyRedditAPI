Before do
  load_server_config
  Reddit::Api.base_uri @address
  Reddit::Submission.base_uri @address
  Reddit::Comment.base_uri @address
  @api = Reddit::Api.new @user, @pass
  @api.login
  @submission ||= @api.browse("reddit_test0")[0]
end

Given /^I enter some text$/ do
  @text = "SOME COMMENT"
end

Then /^I should be able to add a comment$/ do
  @submission.add_comment(@text).should be true
end

Given /^I have a comment$/ do
  @submission.add_comment("a comment")
  @comment = @submission.comments.last
end

Then /^I should be able to hide the comment$/ do
  @comment.hide
end

Then /^I should be able to remove the comment$/ do
  @comment.remove
end

Then /^I should be able to approve the comment$/ do
  @comment.approve
end


