require "minitest/autorun"
require "build_book_music"

class BuildBookMusicTest < Minitest::Test
  def test_call
    assert_equal ["1.json", "2.json", "3.json"].to_s, BuildBookMusic.call(["1.json", "2.json", "3.json"])
  end
end
