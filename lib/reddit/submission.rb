module Reddit
  class Submission < Base
    attr_reader :domain, :media_embed, :subreddit, :selftext_html, :selftext, :likes, :saved, :clicked, :author, :media, :score, :over_18, :hidden, :thumbnail, :subreddit_id, :downs, :is_self, :permalink, :name, :created, :url, :title, :created_utc, :num_comments, :ups

    def initialize(data)
      json = data
      parse(json)
    end

    def inspect
      "<Reddit::Submission id='#{id}' author='#{author}' title='#{title}'>"
    end

    def id
      #TODO Don't hardcode t3, it's in the JSON
      "t3_#{@id}"
    end

    def reload
      #TODO
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
        modhash = data["modhash"] # Needed for api calls
        children        = data["children"]
        children.each do |child|
          data = child["data"]
          submissions << Reddit::Submission.new(data)
        end
        submissions
      end
    end
  end
end
