require "json"

class BuildBookMusic
  def self.call(args)
    # load_changes
    save_output
    # puts message
    # return message
  end

  def self.load_data
    file = File.read("spotify.json")
    data = JSON.parse(file)
    puts data.to_s
    return data
  end
  
  def self.load_changes
    file = File.read("changes.json")
    data = JSON.parse(file)
  end

  def self.save_output
    json_string = JSON.pretty_generate(load_data)

    output_file_path = "output.json"
    File.open(output_file_path, "w") do |file|
      file.write(json_string)
    end
  end
end
