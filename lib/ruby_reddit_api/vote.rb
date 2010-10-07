# @author James Cook
module Reddit
  class Vote < Base
    attr_reader :submission

    def initialize(submission)
      @submission = submission
    end

    # Upvote submission or comment
    # @return [true,false]
    def up
      vote(:up)
    end

    # Downvote submission or comment
    # @return [true,false]
    def down
      vote(:down)
    end

    #@return [String]
    def inspect
      "<Reddit::Vote>"
    end

    protected
    def vote(direction)
      return false unless logged_in?
      up_or_down = direction == :up ? 1 : -1
      resp = self.class.post( "/api/vote", {:body => {:id => submission.id, :dir => up_or_down, :uh => modhash}, :headers => base_headers})
      if resp.code == 200
        return true
      else
        return false
      end
    end
  end
end
