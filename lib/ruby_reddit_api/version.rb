module Reddit
  VERSION = File.exist?("VERSION") ? File.read("VERSION").chomp : ""
end
