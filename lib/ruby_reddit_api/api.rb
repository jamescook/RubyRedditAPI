module Reddit

  # @author James Cook
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

    # Browse submissions by subreddit
    # @param [String] Subreddit to browse
    # @return [Array<Reddit::Submission>]
    def browse(subreddit, options={})
      subreddit = sanitize_subreddit(subreddit)
      options.merge! :handler => "Submission"
      if options[:limit]
        options.merge!({:query => {:limit => options[:limit]}})
      end
      read("/r/#{subreddit}.json", options )
    end

    # Read sent messages
    # @return [Array<Reddit::Message>]
    def sent_messages
      messages :sent
    end

    # Read received messages
    # @return [Array<Reddit::Message>]
    def received_messages
      messages :inbox
    end

    # Read received comments
    # @return [Array<Reddit::Message>]
    def comments
      messages :comments
    end

    # Read post replies
    # @return [Array<Reddit::Message>]
    def post_replies
      messages :selfreply
    end

    protected
    def messages(kind)
      read("/message/#{kind.to_s}.json", :handler => "Message")
    end
  end
end
