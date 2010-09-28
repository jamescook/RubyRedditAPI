module BaseHelpers
  def load_server_config
    @address, @post, @user, @pass = parse_config.compact
  end

  protected
  def parse_config
    file = File.exist?("features/reddit.yml") ? YAML.load_file("features/reddit.yml") : {}
    server = file.fetch("server"){ server_defaults }
    return [ server["address"], server["port"], server["test_user"], server["test_pass"] ]
  end

  def server_defaults
    {"address" => "reddit.local", "port" => "80", "test_user" => "reddit", "test_pass" => "password"}
  end
end
World(BaseHelpers)
