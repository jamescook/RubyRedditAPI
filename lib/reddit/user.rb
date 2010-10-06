
module Reddit
  class User < Api
    attr_reader :name, :debug, :created, :created_utc, :link_karma, :comment_karma, :is_mod, :has_mod_mail, :kind
    def initialize(json)
      @debug = StringIO.new
      parse(json)
    end

    def inspect
      "<Reddit::User name='#{name}'>"
    end

    def id
      "#{kind}_#{@id}"
    end

    def to_s
      name
    end

    def friend
      capture_user_id
      resp=self.class.post("/api/friend", {:body => {:name => name, :container => user_id, :type => "friend", :uh => modhash}, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end

    def unfriend
      capture_user_id
      resp=self.class.post("/api/unfriend", {:body => {:name => name, :container => user_id, :type => "friend", :uh => modhash}, :headers => base_headers, :debug_output => @debug })
      resp.code == 200
    end

    protected
    def parse(json)
      json.keys.each do |key|
        instance_variable_set("@#{key}", json[key])
      end
    end

    def self.parse(json)
      kind, data = json["kind"], json["data"]
      data["kind"] = kind
      return Reddit::User.new(data)
    end
  end
end
