# frozen_string_literal: true

require "yaml"

module AdventOfCodeCLI
  # Store and retrieve configuration
  class Config
    CONFIG_FILE_NAME = ".aoc_config"

    def self.save_config(details)
      File.write(CONFIG_FILE_NAME, details.to_yaml)
    end

    def self.load_config
      YAML.load_file(CONFIG_FILE_NAME)
    end
  end
end
