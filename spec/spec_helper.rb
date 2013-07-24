require "bundler"
Bundler.setup

require "webmock"
require "pry"

if ENV["COV"]
  require "simplecov"
  SimpleCov.start
end

require_relative "../lib/ruby_reddit_api"

def read_fixture(file)
  File.read("spec/fixtures/#{file}")
end

WebMock.disable_net_connect!
