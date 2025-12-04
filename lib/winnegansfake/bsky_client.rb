require "fileutils"

module WinnegansFake
  class BskyClient
    include Minisky::Requests

    CONFIG_PATH = "tmp/bluesky.yml".freeze

    attr_reader :config

    def initialize
      FileUtils.touch(CONFIG_PATH)
      @config = YAML.safe_load_file(CONFIG_PATH, fallback: {}).
                  merge(id: Config.bsky_id, pass: Config.bsky_pass)
    end

    def host
      "bsky.social"
    end

    def save_config
      File.write(CONFIG_PATH, YAML.dump(config))
    end
  end

end
