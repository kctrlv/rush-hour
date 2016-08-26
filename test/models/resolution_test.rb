require_relative '../test_helper'

class ResolutionTest < Minitest::Test
  include TestHelpers

  def test_can_be_created_with_width_and_height
    data = { width: "1920", height: "1080" }

    res = Resolution.create(data)

    assert_equal "1920", res.width
    assert_equal "1080", res.height
    assert res.valid?
  end

  def test_is_invalid_with_missing_width
    data = { width: "1920", height: nil }

    res = Resolution.create(data)

    assert res.height.nil?
    refute res.valid?
  end

  def test_is_invalid_with_missing_height
    data = { width: nil, height: "1080" }

    res = Resolution.create(data)

    assert res.width.nil?
    refute res.valid?
  end

  def test_it_only_adds_unique_data
    data_1 = { width: "1920", height: "1080" }
    data_2 = { width: "1440", height: "1080" }
    data_3 = { width: "1920", height: "900" }

    assert_equal 0, Resolution.count

    res_1 = Resolution.create(data_1)
    res_2 = Resolution.create(data_2)
    res_3 = Resolution.create(data_3)

    assert_equal 3, Resolution.count
    assert res_1.valid? && res_2.valid? && res_3.valid?

    res_4 = Resolution.create(data_1)

    assert_equal 3, Resolution.count
    refute res_4.valid?
  end

  def test_resolutions_for_all
    make_payloads
    assert_equal 3, Resolution.resolutions_for_all.count
    assert_equal 1, Resolution.resolutions_for_all['640x480']
    assert_equal 4, Resolution.resolutions_for_all['1920x1280']
  end
end
