ENV["RACK_ENV"] ||= "test"

require 'bundler'
Bundler.require

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara/dsl'
require 'database_cleaner'
require 'pg'

Capybara.app = RushHour::Server

DatabaseCleaner.strategy = :truncation

module TestHelpers
  include Rack::Test::Methods
  def app
    RushHour::Server
  end

  def setup
    DatabaseCleaner.clean
    super
  end

  def teardown
    DatabaseCleaner.clean
    super
  end

  def make_payloads
    params_client1 = {
      identifier: "jumpstartlab",
      rootUrl: "http://jumpstartlab.com"
    }
    params_client2 = {
      identifier: "google",
      rootUrl: "http://google.com"
    }
    params_client3 = {
      identifier: "mysite",
      rootUrl: "http://mysite.com"
    }
    params_pay1 = { payload: '{
      "url":"http://jumpstartlab.com/",
      "requestedAt":"2013-02-16 21:38:20 -0700",
      "respondedIn":37,
      "referredBy":"http://jumpstartlab.com",
      "requestType":"GET",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"}',
      identifier: "jumpstartlab"
    }
    params_pay2 = { payload: '{
      "url":"http://google.com",
      "requestedAt":"2013-03-21 21:38:21 -0700",
      "respondedIn":41,
      "referredBy":"http://google.com",
      "requestType":"POST",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"800",
      "resolutionHeight":"600",
      "ip":"34.32.40.211"}',
      identifier: "google"
    }
    params_pay3 = { payload: '{
      "url":"http://jumpstartlab.com/",
      "requestedAt":"2015-02-16 21:38:22 -0700",
      "respondedIn":40,
      "referredBy":"http://google.com",
      "requestType":"GET",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"23.20.40.211" }',
      identifier: "jumpstartlab",
    }
    params_pay4 = { payload: '{
      "url":"http://mysite.com/",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":32,
      "referredBy":"http://www.google.com",
      "requestType":"GET",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"5.6.7.8"}',
      identifier: "mysite"
    }
    params_pay5 = { payload: '{
      "url":"http://jumpstartlab.com/blog",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://www.bing.com",
      "requestType":"GET",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"5.5.4.3" }',
      identifier: "jumpstartlab"
    }
    params_pay6 = { payload: '{
      "url":"http://jumpstartlab.com/",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":60,
      "referredBy":"http://www.yahoo.com",
      "requestType":"POST",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:48.0) Gecko/20100101 Firefox/48.0",
      "resolutionWidth":"640",
      "resolutionHeight":"480",
      "ip":"1.2.3.4" }',
      identifier: "jumpstartlab"
    }
    c1 = ClientCreator.create(params_client1)
    c1.save
    c2 = ClientCreator.create(params_client2)
    c2.save
    c3 = ClientCreator.create(params_client3)
    c3.save
    pr1 = CreatePayloadRequest.create(params_pay1)
    pr1.save
    pr2 = CreatePayloadRequest.create(params_pay2)
    pr2.save
    pr3 = CreatePayloadRequest.create(params_pay3)
    pr3.save
    pr4 = CreatePayloadRequest.create(params_pay4)
    pr4.save
    pr5 = CreatePayloadRequest.create(params_pay5)
    pr5.save
    pr6 = CreatePayloadRequest.create(params_pay6)
    pr6.save
  end
end
