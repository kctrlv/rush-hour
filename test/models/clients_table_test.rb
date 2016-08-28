require_relative '../test_helper'

class ClientTableTest < Minitest::Test
  include TestHelpers

  def test_information_can_be_sent_to_clients_table
    data = { identifier: "jumpstartlab",
             root_url: "http://jumpstartlab.com/"}
    client = Client.create(data)

    assert_equal "jumpstartlab", client.identifier
    assert_equal "http://jumpstartlab.com/", client.root_url
  end

  def test_identifier_is_identified_as_valid
    data = { identifier: nil,
             root_url: "http://jumpstartlab.com/"}
    client = Client.create(data)

    assert client.identifier.nil?
    refute client.valid?
  end

  def test_root_url_is_identified_as_valid
    data = { identifier: "jumpstartlab",
             root_url: nil}
    client = Client.create(data)

    assert client.root_url.nil?
    refute client.valid?
  end

  def test_clients_are_created_with_client_creator
    create_clients
    assert_equal 8, Client.all.length
  end

  def test_client_knows_its_average_response_time
    create_clients
    create_payloads
    client = Client.find(1)
    assert_equal 41.5, client.average_response_time
  end

  def test_client_knows_its_minimum_response_time
    create_clients
    create_payloads
    client = Client.find(1)
    assert_equal 27, client.min_response_time
  end

  def test_client_knows_its_maximum_response_time
    create_clients
    create_payloads
    client = Client.find(1)
    assert_equal 57, client.max_response_time
  end

  def test_client_knows_its_most_frequent_request_type
    create_clients
    create_payloads
    client = Client.find(1)
    assert_equal "GET", client.most_frequent_request_type
  end

  def test_client_knows_all_http_verbs_used
    create_clients
    create_payloads
    client = Client.find(1)
    assert_equal ['GET', 'POST'], client.all_http_verbs_used
  end

  def test_client_knows_most_to_least_requested_urls
    create_clients
    create_payloads
    client = Client.find(1)
    expected_results = ["http://jumpstartlab.com/apply",
                        "http://jumpstartlab.com/tutorials",
                        "http://jumpstartlab.com/blog"]
    assert_equal expected_results, client.most_to_least_requested_urls
  end

  def test_client_knows_browser_breakdown
    create_clients
    create_payloads
    client = Client.find(1)
    assert_equal 'Chrome', client.browser_breakdown.keys[0]
    assert_equal 10, client.browser_breakdown.values[0]

  end

  def test_client_knows_os_breakdown
    create_clients
    create_payloads
    client = Client.find(1)
    assert_equal "OS X 10.8.2", client.os_breakdown.keys[0]
    assert_equal 10, client.os_breakdown.values[0]
  end

  def test_client_knows_its_resolutions
    create_clients
    create_payloads
    client = Client.find(1)
    assert_equal "1920x1280", client.resolution_breakdown.keys[0]
    assert_equal 10, client.resolution_breakdown.values[0]
  end

end
