require_relative '../test_helper'

class TargetUrlTest < Minitest::Test
  include TestHelpers

  def test_can_be_created_wih_name
    data = { name: "http://jumpstartlab.com/blog" }

    url = TargetUrl.create(data)

    assert_equal "http://jumpstartlab.com/blog", url.name
    assert url.valid?
  end

  def test_is_invalid_with_missing_name
    url = TargetUrl.create({ name: nil})

    assert url.name.nil?
    refute url.valid?
  end

  def test_it_only_adds_unique_data
    data = { name: "http://jumpstartlab.com/blog" }

    assert_equal 0, TargetUrl.count

    url_1 = TargetUrl.create(data)

    assert_equal 1, TargetUrl.count
    assert url_1.valid?

    url_2 = TargetUrl.create(data)

    assert_equal 1, TargetUrl.count
    refute url_2.valid?
  end

  def test_it_calculates_max_response_time
    make_payloads
    url = PayloadRequest.first.target_url.name

    assert_equal 60, TargetUrl.max_response_time(url)
  end

  def test_it_calculates_min_response_time
    make_payloads
    url = PayloadRequest.first.target_url.name

    assert_equal 37, TargetUrl.min_response_time(url)
  end

  def test_it_returns_sorted_list_of_response_times
    make_payloads
    url = PayloadRequest.first.target_url.name

    assert_equal [60, 40, 37], TargetUrl.sorted_response_times(url)
  end

  def test_it_calculates_average_response_time
    make_payloads
    url = PayloadRequest.first.target_url.name

    assert_equal 45.67, TargetUrl.average_response_time(url)
  end

  def test_it_returns_http_verbs_associated_with_url
    make_payloads
    url = PayloadRequest.first.target_url.name

    assert_equal ["GET", "POST"], TargetUrl.associated_http_verbs(url)
  end

  def test_it_returns_three_most_popular_referrers
    make_payloads
    url = PayloadRequest.first.target_url.name

    result = ["http://google.com",
              "http://jumpstartlab.com",
              "http://www.yahoo.com"]
    assert_equal result, TargetUrl.top_three_referrers(url)
  end

  def test_it_returns_three_most_popular_user_agents
    make_payloads
    url = PayloadRequest.first.target_url.name

    result = [["Chrome", "OS X 10.8.2"], ["Firefox", "OS X 10.11"]]
    assert_equal result, TargetUrl.top_three_user_agents(url)
  end

  def test_most_to_least_requested
    make_payloads
    most_visited = "http://jumpstartlab.com/"
    second_place = "http://mysite.com/"
    assert_equal most_visited, TargetUrl.most_to_least_requested[0]
    assert_equal second_place, TargetUrl.most_to_least_requested[1]
  end
end
