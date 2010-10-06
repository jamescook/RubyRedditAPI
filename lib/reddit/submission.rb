module Reddit
  class Submission < Api
    attr_reader :domain, :media_embed, :subreddit, :selftext_html, :selftext, :likes, :saved, :clicked, :media, :score, :over_18, :hidden, :thumbnail, :subreddit_id, :downs, :is_self, :permalink, :name, :created, :url, :title, :created_utc, :num_comments, :ups, :kind, :last_comment_id

    def initialize(data)
      parse(data)
      @debug    = StringIO.new
    end

    def inspect
      "<Reddit::Submission id='#{id}' author='#{@author}' title='#{title}'>"
    end

    def id
      "#{kind}_#{@id}"
    end

    def author
      @author_data ||= read("/user/#{@author}/about.json", :handler => "User")
    end

    def add_comment(text)
      resp = self.class.post("/api/comment", {:body => {:thing_id => id, :text => text, :uh => modhash, :r => subreddit }, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end

    def upvote
      Reddit::Vote.new(self).up
    end

    def downvote
      Reddit::Vote.new(self).down
    end

    def save
      toggle :save
    end

    def unsave
      toggle :unsave
    end

    def hide
      toggle :hide
    end

    def unhide
      toggle :unhide
    end

    def report
      toggle :report
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

    def comments(more=false)
      #TODO Get morechildren to work correctly
      if more && last_comment_id
        opts = {:handler => "Comment",
                :verb => "post",
                :body =>
                  {:link_id => last_comment_id, :depth => 0, :r => subreddit, :uh => modhash, :renderstyle => "json", :pv_hex => "", :id => id}
                }
        return read("/api/morechildren", opts )

      else
        _comments = read( permalink + ".json", {:handler => "Comment", :query => {:limit => 50}} )
        @last_comment_id = _comments.last.id if _comments && _comments.any?
        return _comments
      end
    end

    def parse(json)
      json.keys.each do |key|
        instance_variable_set("@#{key}", json[key])
      end
    end

    class << self

      def parse(json)
        submissions = []
        data            = json["data"]
        Reddit::Base.instance_variable_set("@modhash", data["modhash"]) # Needed for api calls
        children        = data["children"]
        children.each do |child|
          data = child["data"]
          data["kind"] = child["kind"]
          next if data["kind"] =~ /more/
          submissions << Reddit::Submission.new(data)
        end
        submissions
      end
    end

    protected
    def add_distinction(verb)
      resp=self.class.post("/api/distinguish/#{verb}", {:body => {:id => id, :uh => modhash, :r => subreddit, :executed => "distinguishing..."}, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
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
