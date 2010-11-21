# @author James Cook
module Reddit
  class MessageGroup < Thing
    include JsonListing
    attr_reader :debug

    def initialize
      @debug = StringIO.new
    end

    def mark_read(messages)
      mark messages, "read"
    end

    def mark_unread(messages)
      mark messages, "unread"
    end

    protected
    def mark(messages, action)
      ids = ids(messages) 
      action = action == "read" ? "read_message" : "unread_message"
      resp = self.class.post("/api/#{action}", {:body => {:id => ids.join(','), :uh => modhash }, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end

    def ids(messages)
      if messages.is_a?(Array)
        if messages.first.is_a?(Reddit::Message)
          return messages.map{|m| m.id }
        else
          return messages # assume array of String
        end
      else
        return [ messages.id ]
      end
    end
  end
end
