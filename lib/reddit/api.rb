module Reddit

  class Api < Base
    attr_reader :user, :password, :last_action, :debug

    def initialize(user,password, options={})
      @user     = user
      @password = password
      @debug    = StringIO.new
    end

    def inspect
      "<Reddit::Api user='#{user}'>"
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
          resp  = klass.parse( JSON.parse(resp.body) )
          return resp
        else
          return false
        end
      end
    end
  end
end
