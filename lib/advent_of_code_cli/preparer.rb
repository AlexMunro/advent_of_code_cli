# frozen_string_literal: true

require "fileutils"

require_relative "./config"
require_relative "../advent_of_code_cli"

module AdventOfCodeCLI
  # Responsible for setting up for a particular day of AOC,
  # specifically downloading the puzzle input and initialising
  # the solution
  class Preparer
    def initialize(day, year, session_cookie)
      @day = day
      @year = year
      @session_cookie = session_cookie
    end

    def self.prep_for(day)
      if (config = Config.load_config)
        preparer = new(day, config[:year], config[:cookie])

        preparer.create_dirs
        preparer.create_input_file
        preparer.create_solution_files
        preparer.create_spec_file
      else
        puts "Config required before preparation - do `aoc init`"
        exit 1
      end
    end

    def create_dirs
      ["inputs", "solutions", "spec", "spec/solutions", daily_solution_dir].each do |dir|
        Dir.mkdir dir unless Dir.exist? dir
      end
    end

    def create_input_file
      # TODO: find a less scary way of doing stuff than URI.open
      #
      file_name = "inputs/day#{double_digit_day}.txt"
      return if File.exist? file_name

      File.open(file_name, "w") { |f| f << fetch_input_from_remote }
      #   case response = fetch_input_from_remote
      #   when Net::HTTPSuccess
      #     File.open(file_name, "w") { |f| f << response.body }
      #   when Net::HTTPForbidden
      #     puts "Could not access the input file. Is your session key correct?"
      #   when Net::HTTPNotFound
      #     if response.body.include? "unlock"
      #       puts "Input for #{day} is not available yet. Be patient!"
      #     else
      #       puts "Input for #{day} not found. Ensure that day is a number between 1 and 25."
      #     end
      #   else
      #     puts "Fetching request failed with HTTP code #{response.code}"
      #     puts response.body
      #     puts response["Location"]
      #   end
      # end
    end

    def create_solution_files
      write_solution_script_template("one")
      write_solution_script_template("two")

      ::FileUtils.chmod("u+x", "#{daily_solution_dir}/part_one.rb")
      ::FileUtils.chmod("u+x", "#{daily_solution_dir}/part_two.rb")

      write_solution_class_template
    end

    def create_spec_file
      filename = "spec/solutions/day#{double_digit_day}_spec.rb"
      return if File.exist? filename

      File.open(filename, "w") do |file|
        file.puts [
          "# frozen_string_literal: true",
          "",
          "require \"./solutions/day#{double_digit_day}/day#{double_digit_day}\"",
          "",
          "RSpec.describe Day#{double_digit_day} do",
          "end",
        ]
      end
    end

    private

    def double_digit_day
      @double_digit_day ||= format("%02d", @day)
    end

    def daily_solution_dir
      "solutions/day#{double_digit_day}"
    end

    def write_solution_script_template(part)
      filename = "#{daily_solution_dir}/part_#{part}.rb"
      return if File.exist? filename

      File.open(filename, "w") do |file|
        file.puts [
          "#!/usr/bin/env ruby",
          "# frozen_string_literal: true",
          "",
          "require_relative \"./day#{double_digit_day}\"",
          "puts \"The answer to part one is #\{Day#{double_digit_day}.part_#{part}\}\"",
        ]
      end
    end

    def write_solution_class_template
      filename = "#{daily_solution_dir}/day#{double_digit_day}.rb"
      return if File.exist? filename

      File.open(filename, "w") do |file|
        file.puts [
          "# frozen_string_literal: true",
          "",
          "class Day#{double_digit_day}",
          "  def self.part_one",
          "  end",
          "",
          "  def self.part_two",
          "  end",
          "end",
        ]
      end
    end

    def fetch_input_from_remote
      uri = URI("#{AdventOfCodeCLI::AOC_URL}/#{@year}/day/#{format('%1d', @day)}/input")
      puts "Fetching input file from remote server via #{uri}"
      URI.open(uri, "Cookie" => "session=#{@session_cookie}").read
    end
  end
end
