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

end
