require_relative '../test_helper'

class PayloadParserTest < Minitest::Test
  include TestHelpers

  def test_it_can_determine_that_payload_does_not_yet_exist
    make_payloads
    params = { payload: '{
      "url":"http://jumpstartlab.com/",
      "requestedAt":"2017-02-16 21:38:20 -0700",
      "respondedIn":37,
      "referredBy":"http://jumpstartlab.com",
      "requestType":"GET",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"}',
      identifier: "jumpstartlab"
    }
    payload = CreatePayloadRequest.create(params)

    refute CreatePayloadRequest.record_exists?(payload)
  end

  def test_it_can_determine_that_payload_already_exists
    make_payloads
    params = { payload: '{
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
    payload = CreatePayloadRequest.create(params)

    assert CreatePayloadRequest.record_exists?(payload)
  end

  def test_it_can_determine_if_client_doesnt_exist
    make_payloads
    params = { payload: '{
      "url":"http://github.com/",
      "requestedAt":"2013-02-16 21:38:20 -0700",
      "respondedIn":37,
      "referredBy":"http://jumpstartlab.com",
      "requestType":"GET",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"}',
      identifier: "github"
    }

    refute ClientCreator.client_exists?(params)
  end

  def test_it_can_determine_if_client_does_exist
    make_payloads
    params = { payload: '{
      "url":"http://google.com/",
      "requestedAt":"2013-02-16 21:38:20 -0700",
      "respondedIn":37,
      "referredBy":"http://jumpstartlab.com",
      "requestType":"GET",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"}',
      identifier: "google"
    }

    assert ClientCreator.client_exists?(params)
  end

end
