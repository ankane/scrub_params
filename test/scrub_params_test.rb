require_relative "test_helper"

class TestScrubParams < Minitest::Test

  def test_scrub
    params =
      ActionController::Parameters.new({
        "name" => "Hello <script>alert('World')</script>",
        "tags" => ["<b>awesome</b>", "<a href='javascript:void();'>hack</a>"],
        "car" => {
          "make" => "<blink>Tesla</blink>"
        }
      })
    params.scrub!
    expected = {
      "name" => "Hello alert('World')",
      "tags" => ["awesome", "hack"],
      "car" => {
        "make" => "Tesla"
      }
    }
    assert_equal expected, params
  end

  def test_ampersand
    params = ActionController::Parameters.new({"name" => "Ben & Jerry’s"})
    params.scrub!
    assert_equal "Ben & Jerry’s", params["name"]
  end

  def test_arrows
    params = ActionController::Parameters.new({"name" => "2 > 1 and 1 < 2"})
    params.scrub!
    assert_equal "2 > 1 and 1 < 2", params["name"]
  end

end
