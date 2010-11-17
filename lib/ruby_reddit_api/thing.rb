module Reddit
  # @author James Cook
  class Thing < Base
    include JsonListing

    def initialize(data)
      parse(data)
      @debug    = StringIO.new
    end

    # The reddit ID of this entity
    # @return [String]
    def id
      "#{kind}_#{@id}"
    end

    # The author of the entity. The data is lazy-loaded and cached on the object
    # @return [Reddit::User]
    def author
      response = read("/user/#{@author}/about.json", :handler => "User") if @author
      @author_data ||= response[0] if response
    end

    # Report thing
    # @return [true,false]
    def report
      toggle :report
    end

    def toggle(which)
      return false unless logged_in?
      mapping = {:save => "save", :unsave => "unsave", :hide => "hidden", :unhide => "unhidden", :report => "report"}
      mode = mapping[which]
      resp = self.class.post("/api/#{which}", {:body => {:id => id, :uh => modhash, :r => subreddit, :executed => mode }, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end
  end
end
