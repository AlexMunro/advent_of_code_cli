# frozen_string_literal: true

require "thor"

require_relative "./initialiser"
require_relative "./preparer"
require_relative "./submitter"

module AdventOfCodeCLI
  # Commands that can be used to interact with this Advent of Code CLI
  class Cli < Thor
    desc "init", "initialise config including your AoC session key and year in this directory"
    def init
      Initialiser.init_aoc
    end

    desc "prepare --day", "prepare input and solution files for the given day (number from 1-25)"
    option :day, required: true, type: :numeric, aliases: [:d]
    def prepare
      Preparer.prep_for(options[:day])
    end

    desc "submit --day --part [ANSWER]", "submit a solution for a given day and part"
    option :day, required: true, type: :numeric, aliases: [:d]
    option :part, required: true, type: :numeric, aliases: [:p]
    def submit(answer)
      Submitter.submit_for(options[:day], options[:part], answer)
    end
  end
end

AdventOfCodeCLI::Cli.start(ARGV)
