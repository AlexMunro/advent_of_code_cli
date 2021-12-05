# frozen_string_literal: true

require_relative "./config"
require_relative "./web_client"

require "open-uri"
require "net/http"
require "nokogiri"

module AdventOfCodeCLI
  class Submitter
    def initialize(day, part, answer, year, session_cookie)
      @day = day
      @year = year
      @part = part
      @answer = answer
      @session_cookie = session_cookie
    end

    def self.submit_for(day, part, answer)
      if (config = Config.load_config)
        submitter = new(day, part, answer, config[:year], config[:cookie])
        submitter.send_request
      else
        puts "Config required before submission - do `aoc init`"
        exit 1
      end
    end

    def send_request
      httparty_response = WebClient.submit(@year, @day, @part, @answer, @session_cookie)

      case httparty_response.response
      when Net::HTTPSuccess
        puts Nokogiri::HTML(httparty_response.body).search("article").inner_text
      when Net::HTTPBadRequest
        puts "Could not access the submission page. Is your session key correct?"
      when Net::HTTPNotFound
        puts "Submission page not found for day #{day}"
      else
        puts "Submission request failed with HTTP code #{response.code}"
        puts response.body
        puts response["Location"]
      end
    end

    private

    def submission_url
      "#{AdventOfCodeCLI::AOC_URL}/#{@year}/#{@day}/answer"
    end

    def submission_data
      {
        level: @part,
        answer: @answer,
      }
    end

    def header
      { "Cookie" => "session=#{@session_cookie}" }
    end
  end
end
