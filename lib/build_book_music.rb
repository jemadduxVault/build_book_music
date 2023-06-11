require "json"

class BuildBookMusic
  def self.call(args)
    return nil unless valid_inputs?(args)

    puts "Loading data: #{args}"
    data = load_data(args[0])
    changes = load_changes(args[1])
    changed_data = change_data(data, changes)
    save_output(changed_data, args[2])
  end

  def self.change_data(data, changes)
    return data
  end

  def self.load_data(filename)
    JSON.parse(File.read(filename.to_s))
  end
  
  def self.load_changes(filename)
    JSON.parse(File.read(filename.to_s))
  end

  def self.save_output(data, filename)
    File.open(filename, "w") do |file|
      file.write(JSON.pretty_generate(data))
    end
  end

  def self.valid_inputs?(args)
    message = ""
    message += "Missing <input file>. "   if args[0].nil?
    message += "Missing <changes file>. " if args[1].nil?
    message += "Missing <output file>. "  if args[2].nil?
    puts message if message.length >= 1
    return message.length == 0
  end
end
