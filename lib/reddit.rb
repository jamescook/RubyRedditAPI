$LOAD_PATH.unshift File.dirname(__FILE__)

require "httparty"
require "json"
require "reddit/vote"
require "reddit/submission"
require "reddit/comment"

module Reddit

  class Api
    include HTTParty

    attr_reader :cookie, :user, :password, :last_action, :debug
    attr_accessor :modhash
    base_uri "www.reddit.com"

    def initialize(user,password, options={})
      @user     = user
      @password = password
      @debug    = StringIO.new
    end

    def inspect
      "<Reddit::Api user='#{user}'>"
    end

    def logged_in?
      !!cookie
    end

    def browse(subreddit, options={})
      subreddit = sanitize_subreddit(subreddit)
      options.merge! :handler => "Submission"
      read("/r/#{subreddit}.json", options )
    end

    def read(url, options={})
      unless throttled?
        @debug.rewind
        resp = self.class.send( (options[:verb] || "get"), url, {:query => (options[:query] || {}), :headers => base_headers, :debug_output => @debug})
        if valid_response?(resp)
          @last_action = Time.now
          klass = Reddit.const_get(options[:handler] || "Submission")
          resp  = klass.parse( self, JSON.parse(resp.body) )
          return resp
        end
      end
    end

    def login
      url = action_mapping["login"]["path"]
      capture_session(self.class.post( url, {:body => {:user => user, :passwd => password}, :debug_output => @debug} ) )
      logged_in?
    end

    def base_headers
      {'Cookie' => cookie.to_s, 'user-agent' => user_agent}
    end

    protected
    def valid_response?(response)
      response.code == 200
    end

    def capture_session(response)
      cookies = response.headers["set-cookie"]
      @cookie = cookies
    end

    def throttled?
      @last_action && ( ( Time.now - @last_action ) < 1.0 )
    end

    def sanitize_subreddit(subreddit)
      subreddit.gsub!(/^\/?r\/?/,'')
      subreddit.gsub!(/\.json\Z/,'')
      subreddit
    end

    def action_mapping
      {
        "login"       =>  {"path" => "/api/login",     "verb" => "POST"},
        "vote"        =>  {"path" => "/api/vote",      "verb" => "POST"},
        "save"        =>  {"path" => "/api/save",      "verb" => "POST"},
        "unsave"      =>  {"path" => "/api/unsave",    "verb" => "POST"},
        "comment"     =>  {"path" => "/api/comment",   "verb" => "POST"},
        "subscribe"   =>  {"path" => "/api/subscribe", "verb" => "POST" },
        "comments"    =>  {"path" => "/comments",      "verb" => "GET", "handler" => "Comment" },
        "my_reddits"  =>  {"path" => "/reddits/mine",  "verb" => "GET" },
        "saved"       =>  {"path" => "saved",          "verb" => "GET", "handler" => "Submission"},
        ""            =>  {"path" => "",               "verb" => "GET", "handler" => "Submission"}
      }
    end

    def user_agent
      "Ruby Reddit Client v0.0.1"
    end
  end
end
