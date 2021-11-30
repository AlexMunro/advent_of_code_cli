# frozen_string_literal: true

RSpec.describe AdventOfCodeCli do
  it "has a version number" do
    expect(AdventOfCodeCli::VERSION).not_to be nil
  end

  xdescribe ".init_aoc" do
    subject { described_class.init_aoc }

    it "creates a file with supplied info" do

    end

    it "gives a warning when a config file is already present" do

    end
  end

  xdescribe ".prepare" do
    subject { described_class.prepare(day) }

    context "when provided a valid day" do
      let(:day) { "1" }

      it "creates a folder and fetches data for that day" do

      end
    end

    context "when not provided a valid day" do
      it "throws an error and does not fetch any data" do

      end
    end

    context "when the web server does not respond" do
      it "throws an error and does not create a new folder" do

      end
    end
  end

  xdescribe ".read" do
    subject { described_class.prepare(day) }

  end

  xdescribe ".submit" do

  end
end
