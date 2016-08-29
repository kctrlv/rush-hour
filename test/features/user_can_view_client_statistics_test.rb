require_relative '../test_helper'

class UserCanViewClientStatisticsTest < FeatureTest
  def test_user_can_view_client_statistics
    create_clients
    create_payloads

    visit('/sources/google')
    click_link("View Overall Statistics")

    assert page.has_content?("Avg. Response Time Across All Requests")
    assert page.has_content?("137.47")
  end
end
