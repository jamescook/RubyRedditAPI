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

Then /^I should not be able to edit the comment$/ do
  @comment.edit( "1234" ).should be false
end

Then /^I should be able to edit the comment$/ do
  @comment.edit( "1234" ).should be true
end

Then /^I should be able to moderator distinguish the comment$/ do
  @comment.moderator_distinguish
end

Then /^I should be able to indistinguish the comment$/ do
  @comment.indistinguish
end

Then /^I should be able to admin distinguish the comment$/ do
  @comment.admin_distinguish
end

Then /^I should be able to reply to the comment$/ do
  @comment.reply("a reply").should be true
end

