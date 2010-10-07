module Reddit
  # @author James Cook
  class User < Api
    include JSONListing
    attr_reader :name, :debug, :created, :created_utc, :link_karma, :comment_karma, :is_mod, :has_mod_mail, :kind
    def initialize(json)
      @debug = StringIO.new
      parse(json)
    end

    def inspect
      "<Reddit::User name='#{name}'>"
    end

    # The reddit ID of this submission
    # @return [String]
    def id
      "#{kind}_#{@id}"
    end

    # @return [String]
    def to_s
      name
    end

    # Add redditor as friend. Requires a authenticated user.
    # @return [true,false]
    def friend
      capture_user_id
      resp=self.class.post("/api/friend", {:body => {:name => name, :container => user_id, :type => "friend", :uh => modhash}, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end

    # Remove redditor as friend. Requires a authenticated user.
    # @return [true,false]
    def unfriend
      capture_user_id
      resp=self.class.post("/api/unfriend", {:body => {:name => name, :container => user_id, :type => "friend", :uh => modhash}, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end
  end
end
