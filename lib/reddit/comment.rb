module Reddit
  class Comment < Api
    attr_reader :body, :subreddit_id, :name, :created, :downs, :author, :created_utc, :body_html, :link_id, :parent_id, :likes, :replies, :subreddit, :ups, :debug, :kind
    def initialize(json)
      parse(json)
      @debug = StringIO.new
    end

    def inspect
      "<Reddit::Comment author='#{author}' body='#{short_body}'>"
    end

    def id
      "#{kind}_#{@id}"
    end

    def to_s
      body
    end

    def upvote
      Vote.new(self).up
    end

    def downvote
      Vote.new(self).down
    end

    def short_body
      str = body.to_s
      if str.size > 15
        str[0..15] + "..."
      else
        body
      end
    end

    def parse(json)
      json.keys.each do |key|
        instance_variable_set("@#{key}", json[key])
      end
    end

    class << self
      def parse(json)
        comments = []
        details, results = json # TODO figure out this array dealio. First is submission detail?
        data = results["data"]
        modhash = data["modhash"] # Needed for api calls
        children        = data["children"]
        children.each do |child|
          @kind = child["kind"] if @kind.nil?
          data["kind"] = child["kind"]
          comments << Reddit::Comment.new(data)
        end
        comments
      end
    end
  end
end
