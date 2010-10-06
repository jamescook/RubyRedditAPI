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

    def sent_messages
      messages :sent
    end

    def received_messages
      messages :inbox
    end

    def comments
      messages :comments
    end

    def post_replies
      messages :selfreply
    end

    protected
    def messages(kind)
      read("/message/#{kind.to_s}.json", :handler => "Message")
    end
  end
end
