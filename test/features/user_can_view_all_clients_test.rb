require_relative '../test_helper'

class UserCanViewAllClientsTest < FeatureTest
  def test_user_can_view_all_clients
    create_clients
    create_payloads

    visit('/sources')

    assert page.has_content?("Palantir")
    assert page.has_content?("Turing")
    assert page.has_content?("Root Website")
  end
end
