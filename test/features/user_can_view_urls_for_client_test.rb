require_relative '../test_helper'

class UserCanViewAllClientsTest < FeatureTest
  def test_user_can_view_all_clients
    create_clients
    create_payloads

    visit('/sources/apple')
    click_link("View Statistics for Specific URLs")

    assert page.has_content?("buy")
    assert page.has_content?("cart")
    assert page.has_content?("shop")
  end
end