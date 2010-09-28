module Reddit
  class Submission < Api
    attr_reader :domain, :media_embed, :subreddit, :selftext_html, :selftext, :likes, :saved, :clicked, :author, :media, :score, :over_18, :hidden, :thumbnail, :subreddit_id, :downs, :is_self, :permalink, :name, :created, :url, :title, :created_utc, :num_comments, :ups, :kind

    def initialize(data)
      json = data
      parse(json)
      @debug    = StringIO.new
    end

    def inspect
      "<Reddit::Submission id='#{id}' author='#{author}' title='#{title}'>"
    end

    def id
      #TODO Don't hardcode t3, it's in the JSON
      "#{kind}_#{@id}"
    end

    def reload
      #TODO
    end

    #thing_id:t6_2f
    #text:THIS IS A COMMENT
    #r:reddit_test0  # subreddit
    #uh:reddit  #modhash?
    def add_comment(text)
      self.class.post("/api/comment", {:body => {:thing_id => id, :text => text, :uh => modhash, :r => subreddit }, :headers => base_headers, :debug_output => @debug })
    end

    def delete_comment(id)
    end

    def upvote
      Reddit::Vote.new(self).up
    end

    def downvote
      Reddit::Vote.new(self).down
    end

    def comments
      read( permalink + ".json", {:handler => "Comment"} )
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
          submissions << Reddit::Submission.new(data)
        end
        submissions
      end
    end
  end
end
