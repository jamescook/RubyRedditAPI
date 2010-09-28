require File.join( File.dirname(__FILE__), "..", "..", "lib", "reddit.rb")
Before do
  Reddit::Base.instance_variable_set("@cookie", nil)
  load_server_config
  Reddit::Api.base_uri @address
end

Given /^I have a valid user$/ do
  load_server_config
end

Given /^I have a invalid user$/ do
  @user, @pass = "invalid", "user"
end

Given /^I send my user and password to the login API$/ do
  @api = Reddit::Api.new @user, @pass
  @api.login
end

Given /I'm logged in$/ do
  @api = Reddit::Api.new @user, @pass
  @api.login
end

Given /I'm not logged in$/ do
  @api.logout if @api
  @api = Reddit::Api.new @user, "bad pass"
  @api.logout
end

Then /^I should have a valid cookie$/ do
  @api.cookie.should_not == nil
  @api.cookie.should     =~ /reddit_session/
end

Then /^I should not have a valid cookie$/ do
  @api.cookie.should_not == nil
  @api.cookie.should =~ /reddit_first/
end

Then /^I should not have a cookie$/ do
  @api.cookie.should == nil
end

Then /^the stored headers should refer to the cookie$/ do
  @api.base_headers["Cookie"].should == @api.cookie
end

