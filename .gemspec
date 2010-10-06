# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "reddit/version"

Gem::Specification.new do |s|
  s.name        = "ruby_reddit_api"
  s.version     = Reddit::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["James Cook"]
  s.email       = ["jamecook@gmail.com"]
  s.homepage    = "http://github.com/jamescook/RubyRedditAPI"
  s.summary     = "Wrapper for reddit API"
  s.description = "Wraps many reddit API functions such as submission and comments browsing, voting and messaging."
  s.has_rdoc    = false

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "httparty"
  s.add_development_dependency "cucumber"

  s.files        = Dir.glob("{lib}/**/*") + %w(README)
  s.test_files   = Dir.glob("{features}/**/*")
  s.require_path = 'lib'
end
