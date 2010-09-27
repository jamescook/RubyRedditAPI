module Reddit
  class Base
    include HTTParty

    attr_reader :last_action, :debug, :cookie
    attr_accessor :modhash
    base_uri "www.reddit.com"

    def initialize(user,password, options={})
      @user     = user
      @password = password
      @debug    = StringIO.new
    end

    def inspect
      "<Reddit::Base user='#{user}'>"
    end

    def login
      url = action_mapping["login"]["path"]
      capture_session(self.class.post( url, {:body => {:user => user, :passwd => password}, :debug_output => @debug} ) )
      logged_in?
    end

    def cookie
      @@cookie
    end

    def base_headers
      {'Cookie' => cookie.to_s, 'user-agent' => user_agent}
    end

    protected
    def valid_response?(response)
      response.code == 200
    end

    def logged_in?
      !!cookie
    end

    def capture_session(response)
      cookies = response.headers["set-cookie"]
      @@cookie = cookies
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
