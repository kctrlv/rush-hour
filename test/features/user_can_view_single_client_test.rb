require_relative '../test_helper'

class UserCanViewSingleClientTest < FeatureTest
  def test_user_can_view_single_client
    create_clients
    create_payloads

    visit('/sources')
    click_link("Google")

    assert page.has_content?("GOOGLE")
    assert page.has_content?("View Overall Statistics")
    assert page.has_content?("View Statistics for Specific URLs")
  end
end
