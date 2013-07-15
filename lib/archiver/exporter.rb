module Archiver
  class Exporter
    attr_reader :data, :options

    def initialize(data, options={})
      options.reverse_merge!({ filename: "data.json" })

      @data     = data
      @options  = options
    end

    def to_json
      Oj.dump(data)
    end

    def write!
      File.open("./lib/data/#{options[:filename]}", "w") { |f| f.write(to_json) }
    end
  end # Exporter
end # Archiver
