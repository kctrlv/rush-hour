require_relative '../test_helper'

class PayloadRequestTest < Minitest::Test
  include TestHelpers
  def setup
    @snake_cased_data = {
      client_id: 1,
      request_type_id: 1,
      target_url_id: 1,
      referrer_url_id: 1,
      resolution_id: 1,
      u_agent_id: 1,
      ip_id: 1 ,
      responded_in: 37,
      requested_at: "2013-02-16 21:38:28 -0700"
    }
  end

  def data_without(unwanted_key)
    @snake_cased_data.reject { |key| key == unwanted_key }
  end

  def test_can_be_created_with_correct_attributes
    req = PayloadRequest.create(@snake_cased_data)
    assert_equal req.request_type_id, 1
    assert_equal req.target_url_id, 1
    assert_equal req.referrer_url_id, 1
    assert_equal req.resolution_id, 1
    assert_equal req.u_agent_id, 1
    assert_equal req.ip_id, 1
    assert_equal req.responded_in, 37
    assert_equal req.requested_at, "2013-02-16 21:38:28 -0700"

    assert_equal true, req.valid?
  end

  def test_is_invalid_with_missing_request_type_id
    req = PayloadRequest.create(data_without(:request_type_id))
    assert req.request_type_id.nil?
    refute req.valid?
  end

  def test_is_invalid_with_missing_target_url_id
    req = PayloadRequest.create(data_without(:target_url_id))
    assert req.target_url_id.nil?
    refute req.valid?
  end

  def test_is_invalid_with_missing_referrer_url_id
    req = PayloadRequest.create(data_without(:referrer_url_id))
    assert req.referrer_url_id.nil?
    refute req.valid?
  end

  def test_is_invalid_with_missing_resolution_id
    req = PayloadRequest.create(data_without(:resolution_id))
    assert req.resolution_id.nil?
    refute req.valid?
  end

  def test_is_invalid_with_missing_u_agent_id
    req = PayloadRequest.create(data_without(:u_agent_id))
    assert req.u_agent_id.nil?
    refute req.valid?
  end

  def test_is_invalid_with_missing_ip_id
    req = PayloadRequest.create(data_without(:ip_id))
    assert req.ip_id.nil?
    refute req.valid?
  end

  def test_is_invalid_with_missing_responded_in
    req = PayloadRequest.create(data_without(:responded_in))
    assert req.responded_in.nil?
    refute req.valid?
  end

  def test_is_invalid_with_missing_requested_at
    req = PayloadRequest.create(data_without(:requested_at))
    assert req.requested_at.nil?
    refute req.valid?
  end

  def test_average_response_time
    make_payloads
    assert_equal 41.17, PayloadRequest.average_response_time
  end

  def test_max_response_time
    make_payloads
    assert_equal 60, PayloadRequest.max_response_time
  end

  def test_min_response_time
    make_payloads
    assert_equal 32, PayloadRequest.min_response_time
    assert_equal 6, PayloadRequest.all.count
  end

  def test_payload_requests_are_created_with_payload_request_creator
    create_clients
    create_payloads
    assert_equal 78, PayloadRequest.all.count
  end
end
