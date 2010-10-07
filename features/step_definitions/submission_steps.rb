Given /^I have a submission$/ do
  load_server_config
  Reddit::Api.base_uri @address
  Reddit::Submission.base_uri @address
  Reddit::Comment.base_uri @address
  @api = Reddit::Api.new @user, @pass
  @api.login
  @submission = @api.browse("reddit_test0")[0]
  if @api.logged_in?
    @submission.add_comment("STOP REPOSTING!!1") if @submission
  else
    raise "Can't run test. Submit failed.."
  end
end

Then /^I should be able to see the author$/ do
  @submission.author.should_not == nil
end

Then /^I should be able to see the title$/ do
  @submission.title.should_not == nil
end

Then /^I should be able to see the selftext$/ do
  @submission.selftext.should_not == nil
end

Then /^I should be able to see the url$/ do
  @submission.url.should_not == nil
end

Then /^I should be able to see the up votes$/ do
  @submission.ups.should_not == nil
end

Then /^I should be able to see the down votes$/ do
  @submission.downs.should_not == nil
end

Then /^I should not be able to upvote it$/ do
  @submission.upvote.should be false
end

Then /^I should not be able to downvote it$/ do
  @submission.downvote.should be false
end

Then /^I should be able to upvote it$/ do
  @submission.upvote.should be true
end

Then /^I should be able to downvote it$/ do
  @submission.downvote.should be true
end

Then /^I should not be able to save the submission$/ do
  @submission.save.should be false
end

Then /^I should not be able to unsave the submission$/ do
  @submission.unsave.should be false
end

Then /^I should not be able to hide the submission$/ do
  @submission.hide.should be false
end

Then /^I should not be able to unhide the submission$/ do
  @submission.unhide.should be false
end

Then /^I should be able to save the submission$/ do
  @submission.save.should be true
end

Then /^I should be able to unsave the submission$/ do
  @submission.unsave.should be true
end

Then /^I should be able to hide the submission$/ do
  result = @submission.hide
  @submission.unhide if result
  result.should be true
end

Then /^I should be able to unhide the submission$/ do
  @submission.unhide.should be true
end

Then /^I should be able to report the submission$/ do
  @submission.report.should be true
end

Then /^I should not be able to report the submission$/ do
  @submission.report.should be false
end

Then /^I should be able to see more comments if needed$/ do
  pending
end

Then /^I should be able to moderator distinguish the submission$/ do
  @submission.moderator_distinguish
end

Then /^I should be able to admin distinguish the submission$/ do
  @submission.admin_distinguish
end

Then /^I should be able to indistinguish the submission$/ do
  @submission.indistinguish
end

Then /^I should be able to see the comments$/ do
  comments = @submission.comments
  comments.size.should > 0
end
