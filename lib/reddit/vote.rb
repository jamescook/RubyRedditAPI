module Reddit
  class Vote
    attr_reader :submission, :session

    def initialize(submission)
      @submission = submission
      @session    = submission.session
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
      return false unless session.logged_in?
      up_or_down = direction == :up ? 1 : -1
      url        = session.send(:action_mapping)["vote"]["path"]
      resp = session.class.post( url, {:body => {:id => submission.id, :dir => up_or_down, :uh => session.modhash}, :headers => session.base_headers})
      if resp.code == 200
        return true
      else
        return false
      end
    end
  end
end
