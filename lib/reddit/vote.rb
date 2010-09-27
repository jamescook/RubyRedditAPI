module Reddit
  class Vote < Base
    attr_reader :submission

    def initialize(submission)
      @submission = submission
    end

    def up
      vote(:up)
    end

    def down
      vote(:down)
    end

    def inspect
      "<Reddit::Vote>"
    end

    protected
    def vote(direction)
      return false unless logged_in?
      up_or_down = direction == :up ? 1 : -1
      url        = self.send(:action_mapping)["vote"]["path"]
      resp = self.class.post( url, {:body => {:id => submission.id, :dir => up_or_down, :uh => modhash}, :headers => base_headers})
      if resp.code == 200
        return true
      else
        return false
      end
    end
  end
end
