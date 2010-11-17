Before do
  load_server_config
  Reddit::Api.base_uri @address
  Reddit::Message.base_uri @address
  Reddit::Base.instance_variable_set("@throttle_duration", 0)
end

Given /^I am logged in$/ do
  @api = Reddit::Api.new @user, @pass
  @api.login
end

When /^I go to the sent messages page$/ do
  @result = @api.sent_messages
end

When /^I go to the unread messages page$/ do
  @result = @api.unread_messages
end

When /^I go to the received messages page$/ do
  @result = @api.received_messages
end

Then /^I should see a listing of messages$/ do
  @result.any?{|r| r.is_a?(Reddit::Message) == false}.should be false
end

Given /^I have received messages$/ do
  @api.received_messages.size.should be > 0
end

Given /^I have unread messages$/ do
  unread = @api.unread_messages
  unless unread.size > 0
    @api.received_messages[0].mark_unread
  end
end

Then /^I should be able to mark them as unread/ do
  unread = @api.unread_messages
  unread.each do |m|
    m.mark_read
  end

  received = @api.received_messages
  received[0].mark_unread

  r = @api.unread_messages
  r.size.should == 1
end

Then /^I should be able to mark them as read$/ do
  received = @api.received_messages
  received.each do |m|
    m.mark_unread
  end
  unread = @api.unread_messages

  unread.size.should be > 0

  unread.each do |m|
    m.mark_read
  end
  
  r = @api.unread_messages
  r.size.should == 0
end
