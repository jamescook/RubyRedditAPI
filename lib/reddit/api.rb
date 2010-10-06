module Reddit

  class Api < Base
    attr_reader :last_action, :debug

    def initialize(user=nil,password=nil, options={})
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
      if options[:limit]
        options.merge!({:query => {:limit => options[:limit]}})
      end
      read("/r/#{subreddit}.json", options )
    end

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
  end
end
