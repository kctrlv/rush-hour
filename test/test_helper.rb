ENV["RACK_ENV"] ||= "test"

require 'bundler'
Bundler.require

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara/dsl'
require 'database_cleaner'
require 'pg'
require './app/models/data_parser'

Capybara.app = RushHour::Server

DatabaseCleaner.strategy = :truncation

module TestHelpers
  include Rack::Test::Methods
  def app     # def app is something that Rack::Test is looking for
    RushHour::Server
  end

  def setup
    @params_client1 = {
      identifier: "jumpstartlab",
      rootUrl: "http://jumpstartlab.com"
    }
    @params_pay1 = {
      payload: {"url":"http://jumpstartlab.com/",
                "requestedAt":"2013-02-16 21:38:28 -0700",
                "respondedIn":37,
                "referredBy":"http://jumpstartlab.com",
                "requestType":"GET",
                "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                "resolutionWidth":"1920",
                "resolutionHeight":"1280",
                "ip":"63.29.38.211"},
              }
    @params_client2 = {
      identifier: "google",
      rootUrl: "http://google.com"
    }
    @params_pay2 = {
      payload: {"url":"http://google.com",
                "requestedAt":"2013-03-21 21:38:28 -0700",
                "respondedIn":41,
                "referredBy":"http://google.com",
                "requestType":"POST",
                "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                "resolutionWidth":"800",
                "resolutionHeight":"600",
                "ip":"34.32.40.211"},
    }
    @params_pay3 = {
      payload: {"url":"http://jumpstartlab.com/",
                "requestedAt":"2015-02-16 21:38:28 -0700",
                "respondedIn":40,
                "referredBy":"http://google.com",
                "requestType":"GET",
                "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                "resolutionWidth":"1920",
                "resolutionHeight":"1280",
                "ip":"23.20.40.211"},
    }

    DatabaseCleaner.clean
    super
  end

  def teardown
    DatabaseCleaner.clean
    super
  end

  def make_payloads
    payload1 = { payload: {
      "url":"http://mysite.com/",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":32,
      "referredBy":"http://www.google.com",
      "requestType":"GET",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"5.6.7.8"
    }}
    payload2 = { payload: {
      "url":"http://mysite.com/blog",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://www.yahoo.com",
      "requestType":"GET",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"5.5.4.3"
    }}
    payload3 = { payload: {
      "url":"http://mysite.com/",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":60,
      "referredBy":"http://www.google.com",
      "requestType":"POST",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:48.0) Gecko/20100101 Firefox/48.0",
      "resolutionWidth":"640",
      "resolutionHeight":"480",
      "ip":"1.2.3.4"
    }}
    client1 = { identifier: "google", rootUrl: "http://www.google.com" }
    client2 = { identifier: "yahoo", rootUrl: "http://www.yahoo.com" }
    client3 = { identifier: "google", rootUrl: "http://www.google.com" }
    DataParser.create(client1)
    DataParser.create(client2)
    DataParser.create(client3)
    DataParser.create(payload1)
    DataParser.create(payload2)
    DataParser.create(payload3)
  end
end
