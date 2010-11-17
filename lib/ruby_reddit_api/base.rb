module Reddit
  # Base module all other classes descend from. Stores the cookie, modhash and user info for many API calls. Handles authentication and directs JSON
  # to the relevant handler.
  # @author James Cook
  class Base
    include HTTParty

    attr_reader :last_action, :debug
    base_uri "www.reddit.com"
    class << self; attr_reader :cookie, :modhash, :user_id, :user, :throttle_duration end

    @throttle_duration = 1.0

    def initialize(options={})
      @debug    = StringIO.new
    end

    # @return [String]
    def inspect
      "<Reddit::Base>"
    end

    # Login to Reddit and capture the cookie
    # @return [Boolean] Login success or failure
    def login
      capture_session(self.class.post( "/api/login", {:body => {:user => @user, :passwd => @password}, :debug_output => @debug} ) )
      logged_in?
    end

    # Remove the cookie to effectively logout of Reddit
    # @return [nil]
    def logout
      Reddit::Base.instance_variable_set("@cookie",nil)
    end

    # @return [String, nil]
    def cookie
      Reddit::Base.cookie
    end

    # A kind of authenticity token for many API calls
    # @return [String, nil]
    def modhash
      Reddit::Base.modhash
    end

    # Reddit's displayed ID for the logged in user
    # @return [String]
    def user_id
      Reddit::Base.user_id
    end

    # Logged in user
    # @return [String]
    def user
      Reddit::Base.user
    end

    # The session is authenticated if the captured cookie shows a valid session is in place
    # @return [true,false]
    def logged_in?
      !!(cookie && (cookie =~ /reddit_session/) != nil)
    end

    # @return String
    def user_agent
      self.class.user_agent
    end

    # HTTP headers to be sent in all API requests. At a minimum, 'User-agent' and 'Cookie' are needed.
    # @return Hash
    def base_headers
      self.class.base_headers
    end

    # Base communication function for nearly all API calls
    # @return [Reddit::Submission, Reddit::Comment, Reddit::User, false] Various reddit-related, json parseable objects
    def read(url, options={})
      unless throttled?
        @debug.rewind
        verb      = (options[:verb] || "get")
        param_key = (verb == "get") ? :query : :body
        resp      = self.class.send( verb, url, {param_key => (options[param_key] || {}), :headers => base_headers, :debug_output => @debug})
        if valid_response?(resp)
          @last_action = Time.now
          klass = Reddit.const_get(options[:handler] || "Submission")
          resp  = klass.parse( JSON.parse(resp.body, :max_nesting => 9_999) )
          return resp
        else
          return false
        end
      end
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
      this_user = read("/user/#{user}/about.json", :handler => "User")[0]
      Reddit::Base.instance_variable_set("@user_id", this_user.id)
    end

    def throttled?
      @last_action && ( ( Time.now - @last_action ) < Reddit::Base.throttle_duration )
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
        "Ruby Reddit Client v#{Reddit::VERSION}"
      end
    end
  end
end
