Before do
  load_server_config
  Reddit::Api.base_uri @address
  Reddit::Message.base_uri @address
end

Given /^I am logged in$/ do
  @api = Reddit::Api.new @user, @pass
  @api.login
end

When /^I go to the sent messages page$/ do
  @result = @api.sent_messages
end

Then /^I should see a listing of messages$/ do
  @result.any?{|r| r.is_a?(Reddit::Message) == false}.should be false
end
