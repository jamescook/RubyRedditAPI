module Reddit
  # @author Joe Bauser
  module Voteable
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      # Upvote thing
      # @return [true,false]
      def upvote
        Reddit::Vote.new(self).up
      end

      # Downvote thing
      # @return [true,false]
      def downvote
        Reddit::Vote.new(self).down
      end
    end
  end
end
