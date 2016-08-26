require_relative '../test_helper'
require 'pry'

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
    ClientCreator.create(@client1)
    ClientCreator.create(@client2)
    DataParser.create(@params1)
    DataParser.create(@params2)
    DataParser.create(@params3)
    url = PayloadRequest.first.target_url.name
    assert_equal 40, TargetUrl.max_response_time(url)
  end
  #
  # def test_it_calculates_min_response_time
  #   ClientCreator.create(@client1)
  #   ClientCreator.create(@client2)
  #   DataParser.create(@params1)
  #   DataParser.create(@params2)
  #   DataParser.create(@params3)
  #   url = PayloadRequest.first.target_url.name
  #   assert_equal 37, TargetUrl.min_response_time(url)
  # end
  #
  # def test_it_returns_sorted_list_of_response_times
  #   ClientCreator.create(@client1)
  #   ClientCreator.create(@client2)
  #   DataParser.create(@params1)
  #   DataParser.create(@params2)
  #   DataParser.create(@params3)
  #   url = PayloadRequest.first.target_url.name
  #   assert_equal [40, 37], TargetUrl.sorted_response_times(url)
  # end
  #
  # def test_it_calculates_average_response_time
  #   ClientCreator.create(@client1)
  #   ClientCreator.create(@client2)
  #   DataParser.create(@params1)
  #   DataParser.create(@params2)
  #   DataParser.create(@params3)
  #   url = PayloadRequest.first.target_url.name
  #   assert_equal 38.5, TargetUrl.average_response_time(url)
  # end
  #
  # def test_it_returns_http_verbs_associated_with_url
  #   ClientCreator.create(@client1)
  #   ClientCreator.create(@client2)
  #   DataParser.create(@params1)
  #   DataParser.create(@params2)
  #   DataParser.create(@params3)
  #   url = PayloadRequest.first.target_url.name
  #   assert_equal ["GET"], TargetUrl.associated_http_verbs(url)
  # end
  #
  # def test_it_returns_three_most_popular_referrers
  #   ClientCreator.create(@client1)
  #   ClientCreator.create(@client2)
  #   DataParser.create(@params1)
  #   DataParser.create(@params2)
  #   DataParser.create(@params3)
  #   url = PayloadRequest.first.target_url.name
  #   result = ["http://google.com", "http://jumpstartlab.com"]
  #   assert_equal result, TargetUrl.top_three_referrers(url)
  # end
  #
  # def test_it_returns_three_most_popular_user_agents
  #   ClientCreator.create(@client1)
  #   ClientCreator.create(@client2)
  #   DataParser.create(@params1)
  #   DataParser.create(@params2)
  #   DataParser.create(@params3)
  #   url = PayloadRequest.first.target_url.name
  #   result = [["Chrome", "OS X 10.8.2"]]
  #   assert_equal result, TargetUrl.top_three_user_agents(url)
  # end
  #
  # def test_most_to_least_requested
  #   make_payloads
  #   most_visited = "http://mysite.com/"
  #   second_place = "http://mysite.com/blog"
  #   assert_equal most_visited, TargetUrl.most_to_least_requested[0]
  #   assert_equal second_place, TargetUrl.most_to_least_requested[1]
  # end
end
