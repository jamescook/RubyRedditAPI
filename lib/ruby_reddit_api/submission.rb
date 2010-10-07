# @author James Cook
module Reddit
  class Submission < Thing
    include JsonListing
    attr_reader :domain, :media_embed, :subreddit, :selftext_html, :selftext, :likes, :saved, :clicked, :media, :score, :over_18, :hidden, :thumbnail, :subreddit_id, :downs, :is_self, :permalink, :name, :created, :url, :title, :created_utc, :num_comments, :ups, :kind, :last_comment_id

    def inspect
      "<Reddit::Submission id='#{id}' author='#{@author}' title='#{title}'>"
    end

    # Add a comment to a submission
    # @param [String] Comment text
    # @return [true,false]
    def add_comment(text)
      resp = self.class.post("/api/comment", {:body => {:thing_id => id, :text => text, :uh => modhash, :r => subreddit }, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end

    # Save submission
    # @return [true,false]
    def save
      toggle :save
    end

    # Unsave submission
    # @return [true,false]
    def unsave
      toggle :unsave
    end

    # Hide submission
    # @return [true,false]
    def hide
      toggle :hide
    end

    # Unhide submission
    # @return [true,false]
    def unhide
      toggle :unhide
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

    # Fetch submission comments
    # @todo Move to 'Thing' class
    # @return [Array<Reddit::Comment>]
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

    protected
    def add_distinction(verb)
      resp=self.class.post("/api/distinguish/#{verb}", {:body => {:id => id, :uh => modhash, :r => subreddit, :executed => "distinguishing..."}, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end
  end
end
