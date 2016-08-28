require_relative '../test_helper'

class UserCanViewAllClientsTest < FeatureTest
  def test_user_can_view_all_clients
    create_clients
    create_payloads

    visit('/sources/jumpstartlab/url')
    click_link("blog")

    assert page.has_content?("Information on http://jumpstartlab.com/blog")
    assert page.has_content?("Max Response time")
    assert page.has_content?("57")
  end
end
