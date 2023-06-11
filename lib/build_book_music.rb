require "json"

class BuildBookMusic
  def self.call(args)
    return nil unless valid_inputs?(args)
    data = load_data(args[0])
    changes = load_changes(args[1])
    changed_data = change_data(data, changes)
    save_output(changed_data, args[2])
  end

  def self.change_data(data, changes)
    ## Add Existing Song to Playlist
    add_songs_changes = changes.select{|c| c[:type] == "add_existing_song_to_playlist"}
    new_playlists = []
    data[:playlists].each do |playlist|
      song_changes = add_songs_changes.select{|c| c[:playlist_id].to_i == playlist[:id].to_i}
      if song_changes.map{|c| c[:song_id]}.length > 0
        playlist[:song_ids] = (playlist[:song_ids] + song_changes.map{|c| c[:song_id]})
      end
      new_playlists << playlist
    end
    data[:playlists] = new_playlists

    ## New Playlist
    new_playlist_changes = changes.select{|c| c[:type] == "create_new_playlist"}
    highest_playlist_id = data[:playlists].map{|p| p[:id]}.max.to_i

    new_playlist_changes.each do |change|
      highest_playlist_id += 1
      data[:playlists] << {id: highest_playlist_id.to_s, owner_id: change[:user_id], song_ids: change[:song_ids]}
    end

    ## Delete Playlist
    delete_playlist_ids = changes.select{|c| c[:type] == "delete_playlist"}.map{|d| d[:playlist_id]}

    new_playlists = []
    data[:playlists].each do |playlist|
      new_playlists << playlist unless delete_playlist_ids.include?(playlist[:id])
    end
    data[:playlists] = new_playlists

    return data
  end

  def self.load_data(filename)
    puts "Loading data:"
    puts ""

    data = JSON.parse(File.read(filename.to_s), symbolize_names: true)
    puts "Loaded:"
    puts "#{data[:users].count} users."
    puts "#{data[:playlists].count} playlists."
    puts "#{data[:songs].count} songs."
    puts ""
    return data
  end
  
  def self.load_changes(filename)
    changes = JSON.parse(File.read(filename.to_s), symbolize_names: true)
    puts "Loading #{changes.count} changes:"

    puts "Changes:"
    puts "#{changes.select{|c| c[:type] == "add_existing_song_to_playlist"}.count} songs added to a playlist."
    puts "#{changes.select{|c| c[:type] == "create_new_playlist"}.count} new playlists created."
    puts "#{changes.select{|c| c[:type] == "delete_playlist"}.count} deleted playlists."
    puts ""
    return changes
  end

  def self.save_output(data, filename)
    puts "Output:"
    puts "#{data[:users].count} users."
    puts "#{data[:playlists].count} playlists."
    puts "#{data[:songs].count} songs."
    puts ""
    File.open(filename, "w") do |file|
      file.write(JSON.pretty_generate(data))
    end
    puts "Done."
  end

  private

  def self.valid_inputs?(args)
    message = ""
    message += "Missing <input file>. "   if args[0].nil?
    message += "Missing <changes file>. " if args[1].nil?
    message += "Missing <output file>. "  if args[2].nil?
    puts message if message.length >= 1
    return message.length == 0
  end
end
