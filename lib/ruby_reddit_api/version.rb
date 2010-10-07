# @author James Cook
module Reddit
  # Capture the code version from the VERSION file
  # @return [String]
  VERSION = File.exist?("VERSION") ? File.read("VERSION").chomp : ""
end
