module Reddit
  class Message < Base
    attr_reader :body, :was_comment, :kind, :first_message, :name, :created, :dest, :created_utc, :body_html, :subreddit, :parent_id, :context, :replies, :subject, :debug
    def initialize(json)
      parse(json)
      @debug    = StringIO.new
    end

    def id
      "#{kind}_#{@id}"
    end

    def author
      @author_data ||= read("/user/#{@author}/about.json", :handler => "User")
    end

    def inspect
      "<Reddit::Message '#{short_body}'>"
    end

    def short_body
      if body.size > 15
        body[0..15]
      else
        body
      end
    end

    def parse(json)
      json.keys.each do |key|
        instance_variable_set("@#{key}", json[key])
      end
    end

    def self.parse(json)
      results = []
      data     = json["data"]

      children = data["children"]
      children.each do |message|
        kind     = message["kind"]
        message["data"]["kind"] = kind
        results << Reddit::Message.new(message["data"])
      end

      return results
    end

  end
end
