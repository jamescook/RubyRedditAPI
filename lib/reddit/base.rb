module Reddit
  class Base
    include HTTParty

    attr_reader :last_action, :debug
    base_uri "www.reddit.com"
    class << self; attr_reader :cookie, :modhash, :user_id, :user, end

    def initialize(options={})
      @debug    = StringIO.new
    end

    def inspect
      "<Reddit::Base user='#{user}'>"
    end

    def login
      capture_session(self.class.post( "/api/login", {:body => {:user => @user, :passwd => @password}, :debug_output => @debug} ) )
      logged_in?
    end

    def logout
      Reddit::Base.instance_variable_set("@cookie",nil)
    end

    def cookie
      Reddit::Base.cookie
    end

    def modhash
      Reddit::Base.modhash
    end

    def user_id
      Reddit::Base.user_id
    end

    def user
      Reddit::Base.user
    end

    def logged_in?
      !!(cookie && (cookie =~ /reddit_session/) != nil)
    end

    def user_agent
      self.class.user_agent
    end

    def base_headers
      self.class.base_headers
    end

    protected
    def valid_response?(response)
      response.code == 200 && response.headers["content-type"].to_s =~ /json/
    end

    def capture_session(response)
      cookies = response.headers["set-cookie"]
      Reddit::Base.instance_variable_set("@cookie", cookies)
      Reddit::Base.instance_variable_set("@user",   @user)
    end

    def capture_user_id
      return true if user_id
      this_user = read("/user/#{user}/about.json", :handler => "User")
      Reddit::Base.instance_variable_set("@user_id", this_user.id)
    end

    def throttled?
      @last_action && ( ( Time.now - @last_action ) < 1.0 )
    end

    def sanitize_subreddit(subreddit)
      subreddit.gsub!(/^\/?r\//,'')
      subreddit.gsub!(/\.json\Z/,'')
      subreddit
    end

    class << self

      def base_headers
        {'Cookie' => Reddit::Base.cookie.to_s, 'user-agent' => user_agent}
      end

      def user_agent
        "Ruby Reddit Client v#{VERSION}"
      end
    end
  end
end
