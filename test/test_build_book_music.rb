require "minitest/autorun"
require "build_book_music"

class BuildBookMusicTest < Minitest::Test
  def test_add_existing_song_to_playlist
    data_in = {
      playlists: [
        {
          id: "1",
          owner_id: "2",
          song_ids: ["8", "32"]
        },
        {
          id: "2",
          owner_id: "1",
          song_ids: ["3", "4"]
        },
      ]
    }
    changes = [
      {
        type: "add_existing_song_to_playlist",
        playlist_id: "1",
        song_id: "4"
      },
      {
        type: "add_existing_song_to_playlist",
        playlist_id: "1",
        song_id: "22"
      }
    ]
    data_out = {
      playlists: [
        {
          id: "1",
          owner_id: "2",
          song_ids: ["8", "32", "4", "22"]
        },
        {
          id: "2",
          owner_id: "1",
          song_ids: ["3", "4"]
        },
      ]
    }

    assert_equal data_out, BuildBookMusic.change_data(data_in, changes)
  end

  def test_create_new_playlist
    data_in = {
      playlists: [
        {
          id: "1",
          owner_id: "2",
          song_ids: ["8", "32"]
        },
        {
          id: "2",
          owner_id: "1",
          song_ids: ["3", "4"]
        },
      ]
    }
    changes = [
      {
        type: "create_new_playlist",
        user_id: "1",
        song_ids: ["4", "5", "6"]
      }
    ]
    data_out = {
      "playlists": [
        {
          id: "1",
          owner_id: "2",
          song_ids: ["8", "32"]
        },
        {
          id: "2",
          owner_id: "1",
          song_ids: ["3", "4"]
        },
        {
          id: "3",
          owner_id: "1",
          song_ids: ["4", "5", "6"]
        },
      ]
    }

    results = BuildBookMusic.change_data(data_in, changes)
    assert_equal 3, results[:playlists].count
    assert_equal data_out, results
  end

  def test_delete_playlist
    data_in = {
      playlists: [
        {
          id: "1",
          owner_id: "2",
          song_ids: ["8", "32"]
        },
        {
          id: "2",
          owner_id: "1",
          song_ids: ["3", "4"]
        },
      ]
    }
    changes = [
      {
        type: "delete_playlist",
        playlist_id: "1"
      }
    ]
    data_out = {
      "playlists": [
        {
          id: "2",
          owner_id: "1",
          song_ids: ["3", "4"]
        }
      ]
    }

    results = BuildBookMusic.change_data(data_in, changes)
    assert_equal 1, results[:playlists].count
    assert_equal data_out, results
  end
end
