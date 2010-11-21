Before do
  load_server_config
  Reddit::Api.base_uri @address
  Reddit::MessageGroup.base_uri @address
  Reddit::Base.instance_variable_set("@throttle_duration", 0)
  @api = Reddit::Api.new @user, @pass
  @api.login
end

When /^I mark all unread messages read$/ do
  group = Reddit::MessageGroup.new
  messages = @api.unread_messages
  result   = group.mark_read messages
  result.should be true
end

When /^I mark all read messages unread$/ do
  group = Reddit::MessageGroup.new
  messages = @api.received_messages
  result   = group.mark_unread messages
  result.should be true
end

Then /^I should have no unread messages$/ do
  @api.unread_messages.should == []
end

Then /^I should have no read messages$/ do
  @api.received_messages.select{|m| !m.was_comment}.map(&:read?).uniq.should  == [false]
end
