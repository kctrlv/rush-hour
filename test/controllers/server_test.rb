require_relative '../test_helper'

class ServerTest < Minitest::Test
  include TestHelpers
  def test_sources_can_receive_params
    post '/sources', { identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com" }

    assert_equal 200, last_response.status
    assert_equal '{"identifier":"jumpstartlab"}', last_response.body
  end

  def test_sources_returns_error_if_identifier_is_not_sent
    post '/sources', { identifier: nil, rootUrl: "http://jumpstartlab.com" }

    assert_equal 400, last_response.status
    assert_equal '400 Bad Request', last_response.body
  end

  def test_sources_returns_error_if_root_url_is_not_sent
    post '/sources', { identifier: "jumpstartlab", rootUrl: nil }

    assert_equal 400, last_response.status
    assert_equal '400 Bad Request', last_response.body
  end

  def test_sources_saves_new_and_unique_clients
    post '/sources', { identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com" }
    client = Client.first

    assert_equal "jumpstartlab", client.identifier
    assert_equal "http://jumpstartlab.com", client.root_url
    assert_equal 1, Client.all.length
  end

  def test_sources_does_not_save_repeat_clients
    post '/sources', { identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com" }
    assert_equal 1, Client.all.length
    post '/sources', { identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com" }

    assert_equal 1, Client.all.length
    assert_equal 403, last_response.status
    assert_equal '403 Forbidden', last_response.body
  end

end


# post '/items', { item: {title: "Learn to test controllers", description: "This is great"} }
#
# assert_equal 200, last_response.status
# assert_equal "Item created", last_response.body
# assert_equal 1, Item.all.length
