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
  def setup
    @params1 = {
      payload: '{"url":"http://jumpstartlab.com/",
                "requestedAt":"2013-02-16 21:38:28 -0700",
                "respondedIn":37,
                "referredBy":"http://google.com",
                "requestType":"GET",
                "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                "resolutionWidth":"1920",
                "resolutionHeight":"1280",
                "ip":"63.29.38.211"}',
      identifier: "jumpstartlab"
    }
    @client1 = {
      identifier: "jumpstartlab",
      rootUrl: "http://jumpstartlab.com"
    }

    @params2 = {
      payload: '{"url":"http://mysite.com",
                "requestedAt":"2013-03-21 21:38:28 -0700",
                "respondedIn":41,
                "referredBy":"http://yahoo.com",
                "requestType":"POST",
                "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                "resolutionWidth":"800",
                "resolutionHeight":"600",
                "ip":"34.32.40.211"}',
      identifier: "mysite"
    }
    @client2 = {
      identifier: "mysite",
      rootUrl: "http://mysite.com"
    }

    @params3 = {
      payload: '{"url":"http://jumpstartlab.com/",
                "requestedAt":"2015-02-16 21:38:28 -0700",
                "respondedIn":40,
                "referredBy":"http://bing.com",
                "requestType":"GET",
                "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                "resolutionWidth":"1920",
                "resolutionHeight":"1280",
                "ip":"23.20.40.211"}',
      identifier: "jumpstartlab"
    }
    DatabaseCleaner.clean
    super
  end

  def teardown
    DatabaseCleaner.clean
    super
  end

  def make_payloads
    data1 = { payload: '{
      "url":"http://jumpstartlab.com/",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":32,
      "referredBy":"http://google.com",
      "requestType":"GET",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"5.6.7.8"
    }', identifier: "jumpstartlab"}
    data2 = { payload: '{
      "url":"http://mysite.com",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://yahoo.com",
      "requestType":"GET",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"5.5.4.3"
    }', identifier: "mysite" }
    data3 = { payload: '{
      "url":"http://jumpstartlab.com/blog",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":60,
      "referredBy":"http://bing.com",
      "requestType":"POST",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:48.0) Gecko/20100101 Firefox/48.0",
      "resolutionWidth":"640",
      "resolutionHeight":"480",
      "ip":"1.2.3.4"
    }', identifier: "jumpstartlab" }
    ClientCreator.create(@client1)
    ClientCreator.create(@client2)
    DataParser.create(data1)
    DataParser.create(data2)
    DataParser.create(data3)
  end
end
