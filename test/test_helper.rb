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
      "referredBy":"http://google.com",
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
      "referredBy":"http://bing.com",
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
      "referredBy":"http://jumpstartlab.com",
      "requestType":"POST",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:48.0) Gecko/20100101 Firefox/48.0",
      "resolutionWidth":"640",
      "resolutionHeight":"480",
      "ip":"1.2.3.4" }',
      identifier: "jumpstartlab"
    }
    ClientCreator.create_and_save(params_client1)
    ClientCreator.create_and_save(params_client2)
    ClientCreator.create_and_save(params_client3)
    CreatePayloadRequest.create_and_save(params_pay1)
    CreatePayloadRequest.create_and_save(params_pay2)
    CreatePayloadRequest.create_and_save(params_pay3)
    CreatePayloadRequest.create_and_save(params_pay4)
    CreatePayloadRequest.create_and_save(params_pay5)
    CreatePayloadRequest.create_and_save(params_pay6)
  end

  def create_clients
    ClientCreator.create_and_save({identifier: 'jumpstartlab', rootUrl: "http://jumpstartlab.com"})
    ClientCreator.create_and_save({identifier: 'google', rootUrl: "http://google.com"})
    ClientCreator.create_and_save({identifier: 'apple', rootUrl: "http://apple.com"})
    ClientCreator.create_and_save({identifier: 'microsoft', rootUrl: "http://microsoft.com"})
    ClientCreator.create_and_save({identifier: 'palantir', rootUrl: "http://palantir.com"})
    ClientCreator.create_and_save({identifier: 'yahoo', rootUrl: "http://yahoo.com"})
    ClientCreator.create_and_save({identifier: 'turing', rootUrl: "http://turing.io"})
    ClientCreator.create_and_save({identifier: 'facebook', rootUrl: "http://facebook.com"})
  end

  def create_payloads
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://jumpstartlab.com/apply","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}', identifier: 'jumpstartlab' })
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-15 21:38:28 -0700","respondedIn":57,"referredBy":"http://jumpstartlab.com/apply","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/POST.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211" }', identifier: 'jumpstartlab'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-14 21:38:28 -0700","respondedIn":47,"referredBy":"http://jumpstartlab.com/apply","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.30.01" }', identifier: 'jumpstartlab'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://jumpstartlab.com/tutorials","requestedAt":"2013-02-17 20:38:43 -0700","respondedIn":47,"referredBy":"http://jumpstartlab.com/apply","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.30.01" }', identifier: 'jumpstartlab'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://jumpstartlab.com/tutorials","requestedAt":"2013-02-15 15:38:43 -0700","respondedIn":47,"referredBy":"http://jumpstartlab.com/apply","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.30.01" }', identifier: 'jumpstartlab'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://jumpstartlab.com/tutorials","requestedAt":"2013-02-16 14:38:28 -0700","respondedIn":47,"referredBy":"http://jumpstartlab.com/apply","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"55.29.28.211" }', identifier: 'jumpstartlab'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://jumpstartlab.com/apply","requestedAt":"2013-02-10 21:38:11 -0700","respondedIn":47,"referredBy":"http://jumpstartlab.com","requestType":"POST","parameters":[],"eventName": "create","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"55.29.28.211" }', identifier: 'jumpstartlab'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://jumpstartlab.com/apply","requestedAt":"2013-02-13 21:28:11 -0700","respondedIn":32,"referredBy":"http://jumpstartlab.com","requestType":"POST","parameters":[],"eventName": "create","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"55.29.28.211" }', identifier: 'jumpstartlab'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://jumpstartlab.com/apply","requestedAt":"2013-02-11 21:28:28 -0700","respondedIn":27,"referredBy":"http://jumpstartlab.com","requestType":"POST","parameters":[],"eventName": "create","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"59.29.38.01" }', identifier: 'jumpstartlab'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://jumpstartlab.com/apply","requestedAt":"2013-02-12 21:38:28 -0700","respondedIn":27,"referredBy":"http://jumpstartlab.com","requestType":"POST","parameters":[],"eventName": "create","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"59.29.38.01" }', identifier: 'jumpstartlab'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/buy","requestedAt":"2014-02-12 11:18:28 -0700","respondedIn":105,"referredBy":"http://apple.com/shop","requestType":"POST","parameters":[],"eventName": "create","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"640","resolutionHeight":"480","ip":"59.29.23.02" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/buy","requestedAt":"2014-02-15 17:18:28 -0700","respondedIn":105,"referredBy":"http://apple.com/shop","requestType":"POST","parameters":[],"eventName": "create","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"640","resolutionHeight":"480","ip":"59.29.43.02" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/buy","requestedAt":"2014-02-17 11:18:28 -0700","respondedIn":105,"referredBy":"http://apple.com/shop","requestType":"POST","parameters":[],"eventName": "create","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"640","resolutionHeight":"480","ip":"59.29.33.02" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/buy","requestedAt":"2014-02-26 21:58:28 -0700","respondedIn":105,"referredBy":"http://apple.com/shop","requestType":"POST","parameters":[],"eventName": "create","userAgent":"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 2.0.50727; Media Center PC 6.0)","resolutionWidth":"640","resolutionHeight":"480","ip":"59.29.38.02" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/buy","requestedAt":"2014-02-28 21:58:28 -0700","respondedIn":56,"referredBy":"http://apple.com/shop","requestType":"POST","parameters":[],"eventName": "create","userAgent":"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 2.0.50727; Media Center PC 6.0)","resolutionWidth":"720","resolutionHeight":"1080","ip":"59.29.77.02" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/buy","requestedAt":"2014-02-07 16:58:28 -0700","respondedIn":75,"referredBy":"http://apple.com/shop","requestType":"POST","parameters":[],"eventName": "create","userAgent":"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 2.0.50727; Media Center PC 6.0)","resolutionWidth":"720","resolutionHeight":"1080","ip":"59.29.65.02" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/buy","requestedAt":"2014-03-16 11:18:21 -0700","respondedIn":35,"referredBy":"http://apple.com/home","requestType":"POST","parameters":[],"eventName": "create","userAgent":"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 2.0.50727; Media Center PC 6.0)","resolutionWidth":"720","resolutionHeight":"1080","ip":"59.29.44.03" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/cart","requestedAt":"2014-03-16 18:18:21 -0700","respondedIn":22,"referredBy":"http://apple.com/home","requestType":"PUT","parameters":[],"eventName": "update","userAgent":"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 2.0.50727; Media Center PC 6.0)","resolutionWidth":"720","resolutionHeight":"1080","ip":"59.29.88.03" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/cart","requestedAt":"2014-03-16 11:18:21 -0700","respondedIn":67,"referredBy":"http://apple.com/home","requestType":"PUT","parameters":[],"eventName": "update","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"640","resolutionHeight":"480","ip":"59.29.65.03" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/shop","requestedAt":"2014-03-16 11:38:28 -0700","respondedIn":105,"referredBy":"http://apple.com/home","requestType":"GET","parameters":[],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"640","resolutionHeight":"480","ip":"59.29.18.03" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/shop","requestedAt":"2014-03-16 15:38:28 -0700","respondedIn":43,"referredBy":"http://apple.com","requestType":"GET","parameters":[],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"640","resolutionHeight":"480","ip":"59.29.36.02" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/shop","requestedAt":"2014-02-16 15:38:28 -0700","respondedIn":105,"referredBy":"http://apple.com","requestType":"GET","parameters":[],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"640","resolutionHeight":"480","ip":"59.29.34.01" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/shop","requestedAt":"2014-02-16 15:38:28 -0700","respondedIn":23,"referredBy":"http://apple.com","requestType":"GET","parameters":[],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"640","resolutionHeight":"480","ip":"59.29.38.02" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/shop","requestedAt":"2014-02-16 11:38:28 -0700","respondedIn":105,"referredBy":"http://apple.com","requestType":"GET","parameters":[],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"640","resolutionHeight":"480","ip":"59.29.38.02" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://apple.com/shop","requestedAt":"2014-02-16 11:38:28 -0700","respondedIn":54,"referredBy":"http://apple.com","requestType":"GET","parameters":[],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"640","resolutionHeight":"480","ip":"59.29.38.02" }', identifier: 'apple'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/about","requestedAt":"2013-01-16 21:38:28 -0700","respondedIn":90,"referredBy":"http://apple.com","requestType":"GET","parameters":["what","huh"],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1080","ip":"59.29.38.03" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/about","requestedAt":"2013-01-16 20:32:28 -0700","respondedIn":440,"referredBy":"http://jumpstartlab.com/technology","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/4.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1080","ip":"63.29.32.213" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/about","requestedAt":"2013-01-16 21:32:28 -0700","respondedIn":90,"referredBy":"http://apple.com","requestType":"GET","parameters":["what","huh"],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1080","ip":"59.29.32.03" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/about","requestedAt":"2013-01-16 21:32:28 -0700","respondedIn":40,"referredBy":"http://jumpstartlab.com/technology","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/4.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1080","ip":"63.29.38.213" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/about","requestedAt":"2013-01-16 23:38:28 -0700","respondedIn":90,"referredBy":"http://apple.com","requestType":"GET","parameters":["what","huh"],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1080","ip":"59.29.38.23" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/about","requestedAt":"2013-01-16 21:38:28 -0700","respondedIn":22,"referredBy":"http://jumpstartlab.com/technology","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/4.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1080","ip":"63.29.38.213" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/about","requestedAt":"2013-01-16 23:38:28 -0700","respondedIn":32,"referredBy":"http://apple.com/research","requestType":"GET","parameters":["what","huh"],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1080","ip":"59.29.38.21" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/search","requestedAt":"2013-01-16 20:38:28 -0700","respondedIn":55,"referredBy":"http://jumpstartlab.com/technology","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/4.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1080","ip":"63.29.38.213" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/search","requestedAt":"2013-01-16 23:38:28 -0700","respondedIn":32,"referredBy":"http://apple.com/research","requestType":"GET","parameters":["what","huh"],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1080","ip":"59.29.38.11" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/search","requestedAt":"2013-01-16 20:38:28 -0700","respondedIn":50,"referredBy":"http://jumpstartlab.com/technology","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/4.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1080","ip":"63.29.38.213" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/search","requestedAt":"2013-01-16 23:38:28 -0700","respondedIn":90,"referredBy":"http://apple.com/research","requestType":"GET","parameters":["what","huh"],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"420","resolutionHeight":"700","ip":"59.29.38.203" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/search","requestedAt":"2013-01-16 20:38:28 -0700","respondedIn":40,"referredBy":"http://jumpstartlab.com/technology","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/4.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"420","resolutionHeight":"700","ip":"63.29.38.201" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/about","requestedAt":"2013-01-16 21:38:28 -0700","respondedIn":77,"referredBy":"http://google.com","requestType":"GET","parameters":["what","huh"],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"420","resolutionHeight":"700","ip":"59.29.38.03" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/about","requestedAt":"2013-01-16 20:38:28 -0700","respondedIn":320,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/4.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"420","resolutionHeight":"700","ip":"63.29.38.202" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/about","requestedAt":"2013-01-16 21:38:28 -0700","respondedIn":21,"referredBy":"http://google.com","requestType":"GET","parameters":["what","huh"],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"420","resolutionHeight":"700","ip":"59.29.38.222" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/about","requestedAt":"2013-01-16 04:38:28 -0700","respondedIn":76,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/4.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1080","ip":"63.29.33.322" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/about","requestedAt":"2013-01-16 21:38:28 -0700","respondedIn":43,"referredBy":"http://google.com","requestType":"GET","parameters":["what","huh"],"eventName": "show","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1080","ip":"59.29.54.23" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://google.com/about","requestedAt":"2013-01-16 20:38:28 -0700","respondedIn":140,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/4.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1080","ip":"63.29.34.03" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-13 03:33:28 -0700","respondedIn":200,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Windows; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.44" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-13 22:38:28 -0700","respondedIn":37,"referredBy":"http://google.com","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.22" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-13 22:34:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["this","that"],"eventName": "beginRegistration","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"500","resolutionHeight":"700","ip":"63.29.34.202" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/news","requestedAt":"2013-01-13 21:11:28 -0700","respondedIn":123,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.203" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/news","requestedAt":"2013-01-14 21:33:28 -0700","respondedIn":123,"referredBy":"http://jumpstartlab.com","requestType":"POST","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.43.214" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-13 22:38:28 -0700","respondedIn":76,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Windows; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.12" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-13 21:38:28 -0700","respondedIn":37,"referredBy":"http://google.com","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.66" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-13 07:34:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["this","that"],"eventName": "beginRegistration","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"500","resolutionHeight":"700","ip":"63.29.43.202" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/news","requestedAt":"2013-01-13 21:07:43 -0700","respondedIn":123,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.214" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/news","requestedAt":"2013-01-14 21:38:54 -0700","respondedIn":56,"referredBy":"http://jumpstartlab.com","requestType":"POST","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.34.214" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-13 23:33:28 -0700","respondedIn":200,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Windows; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.12" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-13 21:45:28 -0700","respondedIn":37,"referredBy":"http://google.com","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.66" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-13 22:20:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["this","that"],"eventName": "beginRegistration","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"500","resolutionHeight":"700","ip":"63.29.34.202" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/news","requestedAt":"2013-01-13 21:45:28 -0700","respondedIn":76,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.214" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/sports","requestedAt":"2013-01-14 10:38:28 -0700","respondedIn":123,"referredBy":"http://jumpstartlab.com","requestType":"POST","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.214" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-13 10:38:28 -0700","respondedIn":200,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Windows; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.33.38.12" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-13 09:38:28 -0700","respondedIn":37,"referredBy":"http://google.com","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.66" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-22 16:44:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["this","that"],"eventName": "beginRegistration","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"500","resolutionHeight":"700","ip":"63.29.34.202" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/sports","requestedAt":"2013-01-13 21:38:28 -0700","respondedIn":164,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.214" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/sports","requestedAt":"2013-01-31 21:13:18 -0700","respondedIn":111,"referredBy":"http://jumpstartlab.com","requestType":"POST","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.214" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-31 12:38:11 -0700","respondedIn":200,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Windows; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.12" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-31 21:38:28 -0700","respondedIn":45,"referredBy":"http://google.com","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.20.66" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-22 22:32:23 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["this","that"],"eventName": "beginRegistration","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"500","resolutionHeight":"700","ip":"63.29.34.202" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/sports","requestedAt":"2013-01-11 21:21:28 -0700","respondedIn":22,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.214" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/news","requestedAt":"2013-01-15 21:26:28 -0700","respondedIn":123,"referredBy":"http://jumpstartlab.com","requestType":"POST","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.214" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-16 12:26:28 -0700","respondedIn":200,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Windows; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.12" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-12-13 21:24:28 -0700","respondedIn":45,"referredBy":"http://google.com","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.66" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-11 20:12:33 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["this","that"],"eventName": "beginRegistration","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"500","resolutionHeight":"700","ip":"63.29.34.202" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/news","requestedAt":"2013-01-13 12:38:28 -0700","respondedIn":123,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.214" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/news","requestedAt":"2013-01-14 17:38:28 -0700","respondedIn":55,"referredBy":"http://jumpstartlab.com","requestType":"POST","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.214" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-23 18:38:12 -0700","respondedIn":212,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Windows; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.12" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-23 14:25:33 -0700","respondedIn":66,"referredBy":"http://google.com","requestType":"GET","parameters":["what","huh"],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.66" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/weather","requestedAt":"2013-01-15 16:27:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["this","that"],"eventName": "beginRegistration","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"500","resolutionHeight":"700","ip":"63.29.34.202" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/news","requestedAt":"2013-01-16 18:25:28 -0700","respondedIn":1232,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.214" }', identifier: 'google'})
    CreatePayloadRequest.create_and_save({ payload: '{"url":"http://yahoo.com/news","requestedAt":"2013-01-16 11:43:33 -0700","respondedIn":1233,"referredBy":"http://jumpstartlab.com","requestType":"POST","parameters":["slow"],"eventName": "beginRegistration","userAgent":"Mozilla/3.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"800","resolutionHeight":"600","ip":"63.29.38.214" }', identifier: 'google'})
  end
end

Capybara.app = RushHour::Server

class FeatureTest < Minitest::Test
  include Capybara::DSL
  include TestHelpers
end
