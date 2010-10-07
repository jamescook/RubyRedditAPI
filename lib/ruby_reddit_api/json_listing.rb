#@author James Cook
module Reddit
  module JsonListing
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods

      # @param [Hash] JSON received from Reddit
      # @return [Array<Reddit::Submission, Reddit::User, Reddit::Comment, Reddit::Message>]
      def parse(json)
        results = []
        if json.is_a?(Array)
          json.each do |j|
            results << parse(j)
          end
        else
          data     = json["data"]
          Reddit::Base.instance_variable_set("@modhash", data["modhash"]) # Needed for api calls

          children = data["children"] || [{"data" => data, "kind" => json["kind"] }]
          children.each do |message|
            kind     = message["kind"]
            message["data"]["kind"] = kind
            results << self.new(message["data"])
          end
        end

        return results.flatten
      end
    end
    module InstanceMethods
      # Iterate over JSON and set instance variables that map to each JSON key
      # @param [Hash] JSON received from Reddit
      # @return [true]
      def parse(json)
        json.keys.each do |key|
          instance_variable_set("@#{key}", json[key])
        end
        true
      end
    end
  end
end
