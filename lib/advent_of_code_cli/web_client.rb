# frozen_string_literal: true

require "httparty"

module AdventOfCodeCLI
  class WebClient
    include HTTParty

    base_uri "https://adventofcode.com"

    def self.get_input(year, day, session_cookie)
      get(
        "/#{year}/day/#{day}/input",
        headers: cookie_header(session_cookie)
      )
    end

    def self.submit(year, day, part, answer, session_cookie)
      post(
        "/#{year}/day/#{day}/answer",
        body: {
          level: part,
          answer: answer
        },
        headers: cookie_header(session_cookie)
      )
    end

    def self.cookie_header(session_cookie)
      cookie_hash = HTTParty::CookieHash.new
      cookie_hash.add_cookies(session: session_cookie)
      { "Cookie" => cookie_hash.to_cookie_string }
    end
  end
end
