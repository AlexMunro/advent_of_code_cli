# frozen_string_literal: true

require "yaml"
require "open-uri"
require "net/http"

module AdventOfCodeCLI
  CONFIG_FILE_NAME = ".aoc_config"

  AOC_URL = "https://adventofcode.com"

  def self.init_aoc
    puts "Which year should we set up for? (e.g. 2021)"
    year = gets
    puts "What is the value of your session cookie on adventofcode.com?"
    cookie = gets
    puts "Would you like to add relevant entries to your .gitignore? (y/n)"
    edit_gitignore = gets.strip.downcase == "y"

    config = { year: year, cookie: cookie }

    File.write(CONFIG_FILE_NAME, config.to_yaml)
    puts "Written new config file to #{CONFIG_FILE_NAME} for #{year}. Happy hacking!"

    if edit_gitignore
      File.open(".gitignore", "a") do |f|
        f.puts
        f.puts "# Added by Advent of Code CLI"
        f.puts CONFIG_FILE_NAME
        f.puts "*input.txt"
      end

      puts "Amended .gitignore file"
    end
  end

  def self.prepare(day)
    unless load_config
      puts "Config required before preparation - do `aoc init`"
      exit 1
    end

    Dir.mkdir "solutions" unless Dir.exist? "solutions"

    dir_name = "solutions/day#{format('%02d', day)}"

    if Dir.exist? dir_name
      puts "Directory already exists, skipping creation"
    else
      Dir.mkdir dir_name
    end

    file_name = "#{dir_name}/input.txt"

    if File.exist? file_name
      puts "Input file already exists, skipping download"
    else
      puts "Fetching input file from remote server"

      url = "#{AOC_URL}/day#{format('%1d', day)}/input"
      uri = URI.parse(url)

      response = Net::HTTP.get_response(uri)

      if response.is_a? Net::HTTPSuccess
        File.open(file_name, "w") { |f| f << response.body }
      elsif response.is_a? Net::HTTPForbidden
        puts ""
      elsif response.is_a? Net::HTTPNotFound
        if response.body.include? "unlock"
          puts "Input for #{day} is not available yet. Be patient!"
        else
          puts "Input for #{day} not found. Ensure that day is a number between 1 and 25."
        end
      else
        puts "Fetching request failed with HTTP code #{response.code}"
      end
    end
  end

  def self.load_config
    @config = YAML.load_file(CONFIG_FILE_NAME)
  end
end
