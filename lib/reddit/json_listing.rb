module Reddit
  module JsonListing
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
      def parse(json)
        results = []
        if json.is_a?(Array)
          json.each do |j|
            results << parse(j)
          end
        else
          data     = json["data"]
          Reddit::Base.instance_variable_set("@modhash", data["modhash"]) # Needed for api calls

          children = data["children"]
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
      def parse(json)
        json.keys.each do |key|
          instance_variable_set("@#{key}", json[key])
        end
      end
    end
  end
end
