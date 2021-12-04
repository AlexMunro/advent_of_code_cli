# frozen_string_literal: true

require_relative "./config"

module AdventOfCodeCLI
  # Ask the user for relevant details and store them in the config file
  class Initialiser
    def self.init_aoc
      puts "Which year should we set up for? (e.g. 2021)"
      year = STDIN.gets.strip
      puts "What is the value of your session cookie on adventofcode.com?"
      cookie = STDIN.gets.strip
      puts "Would you like to add relevant entries to your .gitignore? (y/n)"
      edit_gitignore = STDIN.gets.strip.downcase == "y"

      Config.save_config({ year: year, cookie: cookie })

      puts "Written new config file to #{Config::CONFIG_FILE_NAME} for #{year}. Happy hacking!"

      edit_gitignore_file if edit_gitignore
    end

    def self.edit_gitignore_file
      File.open(".gitignore", "a") do |f|
        f.puts
        f.puts "# Added by Advent of Code CLI"
        f.puts Config::CONFIG_FILE_NAME
        f.puts "inputs/"
      end

      puts "Amended .gitignore file"
    end
  end
end
