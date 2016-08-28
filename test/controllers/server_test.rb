require_relative '../test_helper'
class ServerTest < Minitest::Test
  include TestHelpers

  def test_application_can_create_a_client
    post '/sources', {
      identifier: "jumpstartlab",
      rootUrl: "http://jumpstartlab.com"
    }
    assert_equal 200, last_response.status
    success_data = '{"identifier":"jumpstartlab"}'
    assert_equal success_data, last_response.body
    assert_equal 1, Client.count
  end

  def test_application_cant_create_a_client_without_identifier
    post '/sources', {
      rootUrl: "http://jumpstartlab.com"
    }
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body
    assert_equal 0, Client.count
  end

  def test_application_cant_create_a_client_without_root_url
    post '/sources', {
      identifier: "jumpstartlab"
    }
    assert_equal 400, last_response.status
    assert_equal "Root url can't be blank", last_response.body
    assert_equal 0, Client.count
  end

  def test_application_can_create_a_duplicate_client
    Client.create(ClientParser.parse(
      identifier: "jumpstartlab",
      rootUrl: "http://jumpstartlab.com"
    ))
    post '/sources', {
      identifier: "jumpstartlab",
      rootUrl: "http://jumpstartlab.com"
    }
    assert_equal 403, last_response.status
    assert_equal "Identifier has already been taken", last_response.body
    assert_equal 1, Client.count
  end

  def test_application_accurately_responds_to_invalid_identifier
    get '/sources/nonexistent/data'
    assert_equal "The identifier does not exist", last_response.body
  end

  def test_application_accurately_responds_to_identifier_with_no_payloads
    Client.create(ClientParser.parse(
      identifier: "jumpstartlab",
      rootUrl: "http://jumpstartlab.com"
    ))
    get '/sources/jumpstartlab/data'
    assert_equal "No data has been received for this identifier", last_response.body
  end

  def test_application_accurately_displays_client_statistics
    create_clients
    create_payloads
  end

end
