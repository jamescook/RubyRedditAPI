$LOAD_PATH.unshift File.dirname(__FILE__)

module Reddit
  VERSION = File.exist?("VERSION") ? File.read("VERSION").chomp : ""
end

require "httparty"
require "json"
require "reddit/base"
require "reddit/json_listing"
require "reddit/api"
require "reddit/user"
require "reddit/vote"
require "reddit/submission"
require "reddit/comment"
require "reddit/message"

