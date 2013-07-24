# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "ruby_reddit_api/version"

Gem::Specification.new do |s|
  s.name        = "ruby_reddit_api"
  s.version     = Reddit::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["James Cook"]
  s.email       = ["jcook.rubyist@gmail.com"]
  s.homepage    = "http://github.com/jamescook/RubyRedditAPI"
  s.summary     = "Wrapper for reddit API"
  s.description = "Wraps many reddit API functions such as submission and comments browsing, voting, messaging, friending, and more."
  s.rubyforge_project = 'ruby_reddit_api'

  s.required_rubygems_version = ">= 1.3.6"
  s.required_ruby_version = ">= 1.9.2"

  s.add_dependency "httparty"
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "webmock"

  s.files        = Dir.glob("{lib}/**/*") + %w(README.rdoc)
  s.test_files   = Dir.glob("{spec}/**/*")
  s.require_path = 'lib'
end
