require File.join( File.dirname(__FILE__), "..", "..", "lib", "reddit.rb")
Given /^I have a valid user$/ do
  Reddit::Base.instance_variable_set("@cookie", nil)
  @user, @pass = ["reddit", "password"]
end

Given /^I have a invalid user$/ do
  Reddit::Base.instance_variable_set("@cookie", nil)
  @user, @pass = ["reddit", "xxx"]
end

Given /^I send my user and password to the login API$/ do
  Reddit::Api.base_uri "http://reddit.local/"
  @api = Reddit::Api.new @user, @pass
end

Then /^I should have a valid cookie$/ do
  @api.login
  @api.cookie.should_not == nil
  @api.cookie.should     =~ /reddit_session/
end

Then /^I should not have a valid cookie$/ do
  @api.login
  @api.cookie.should =~ /reddit_first/
end

Then /^the stored headers should refer to the cookie$/ do
  @api.base_headers["Cookie"].should == @api.cookie
end

