# @author James Cook
module Reddit
  class Message < Base
    include JsonListing

    attr_reader :body, :was_comment, :kind, :first_message, :name, :created, :dest, :created_utc, :body_html, :subreddit, :parent_id, :context, :replies, :subject, :debug
    def initialize(json)
      parse(json)
      @debug    = StringIO.new
    end

    # The reddit ID of this message
    # @return [String]
    def id
      "#{kind}_#{@id}"
    end

    # The author of the message. The data is lazy-loaded and cached on the message
    # @return [Reddit::User]
    def author
      @author_data ||= read("/user/#{@author}/about.json", :handler => "User")
    end

    def inspect
      "<Reddit::Message '#{short_body}'>"
    end

    # Trimmed comment body suitable for #inspect
    # @return [String]
    def short_body
      if body.size > 15
        body[0..15]
      else
        body
      end
    end
  end
end
