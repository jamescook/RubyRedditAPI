module Reddit
  # @author James Cook
  class Comment < Thing

    include JsonListing
    attr_reader :body, :subreddit_id, :name, :created, :downs, :author, :created_utc, :body_html, :link_id, :parent_id, :likes, :num_comments, :subreddit, :ups, :debug, :kind, :replies
    def initialize(json, options={})
      mode = options.fetch(:mode){ :json }
      if mode == :json
        parse(json)
      end

      if mode == :replies
        json.keys.each do |key|
          instance_variable_set("@#{key}", json[key])
        end
      end

      if replies.is_a?(Hash)
        handle_replies(replies)
      end

      @debug = StringIO.new
    end

    def inspect
      "<Reddit::Comment author='#{@author}' body='#{short_body}' replies='#{replies.size}' ups='#{ups}' downs='#{downs}'>"
    end

    # @return [String]
    def to_s
      body
    end

    # Fetch comments
    # @return [Array<Reddit::Comment>]
    def comments
      opts = {:handler => "Comment",
              :verb => "post",
              :body =>
                {:link_id => id, :depth => 10, :r => subreddit, :uh => modhash, :renderstyle => "json", :pv_hex => "", :id => id}
              }
      return read("/api/morechildren", opts )
    end

    # Modify a comment
    # @return [true,false]
    def edit(newtext)
      resp=self.class.post("/api/editusertext", {:body => {:thing_id => id, :uh => modhash, :r => subreddit, :text => newtext }, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end

    # Hide a comment
    # @return [true,false]
    def hide
      resp=self.class.post("/api/del", {:body => {:id => id, :uh => modhash, :r => subreddit, :executed => "removed" }, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end

    # Remove a comment
    # @return [true,false]
    def remove
      resp=self.class.post("/api/remove", {:body => {:id => id, :uh => modhash, :r => subreddit}, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end

    # Approve a comment
    # @return [true,false]
    def approve
      resp=self.class.post("/api/approve", {:body => {:id => id, :uh => modhash, :r => subreddit}, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end

    def moderator_distinguish
      add_distinction "yes"
    end

    def admin_distinguish
      add_distinction "admin"
    end

    def indistinguish
      add_distinction "no"
    end

    # Reply to another comment
    # @return [true,false]
    def reply(text)
      resp = self.class.post("/api/comment", {:body => {:thing_id => id, :text => text, :uh => modhash, :r => subreddit }, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end

    # Trimmed comment body suitable for #inspect
    # @return [String]
    def short_body
      str = body.to_s.strip
      if str.size > 15
        str[0..15] + "..."
      else
        body
      end
    end

    def add_distinction(verb)
      resp=self.class.post("/api/distinguish/#{verb}", {:body => {:id => id, :uh => modhash, :r => subreddit, :executed => "distinguishing..."}, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end

    # Parse nested comment hashes into a Comment
    # @param  [Hash] JSON containing reply data
    # @return [true]
    def handle_replies(data)
       dup = data.dup
       _kind, data       = dup["kind"],     dup["data"]
       modhash, children = data["modhash"], data["children"]
       if children.is_a?(Array)
         @replies = children.map{|reply| Comment.new(reply["data"], :mode => :replies) }
       end
       true
    end
  end
end
