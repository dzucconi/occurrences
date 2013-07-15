module Archiver
  class Exporter
    attr_reader :data, :options

    def initialize(data, options={})
      options.reverse_merge!({ filename: "data", as: :json })

      @data     = data
      @options  = options
    end

    def to_json
      Oj.dump(data, mode: :compat)
    end

    def to_rb
      data
    end

    def write!
      File.open("./lib/data/#{options[:filename]}.#{options[:as]}", "w") do |f|
        f.write(self.send("to_#{options[:as]}"))
      end
    end
  end # Exporter
end # Archiver
