# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "advent_of_code_cli/version"

Gem::Specification.new do |spec|
  spec.name          = "advent_of_code_cli"
  spec.version       = AdventOfCodeCLI::VERSION
  spec.authors       = ["Alex Munro"]
  spec.email         = ["alexmunro91@gmail.com"]

  spec.summary       = "Yet another Advent of Code CLI util!"
  spec.description   = "Do Advent of Code-y stuff without going to adventofcode.com"
  spec.homepage      = "https://github.com/AlexMunro/advent_of_code-cli"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.23"
  spec.metadata = {
    "rubygems_mfa_required" => "true"
  }

  spec.required_ruby_version = ">= 2.0"
end
