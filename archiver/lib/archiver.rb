lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "mechanize"
require "chronic"
require "oj"

require_relative "core_ext/hash"
require_relative "core_ext/object"
require_relative "core_ext/array"
require_relative "core_ext/time"

require_relative "archiver/defaults"
require_relative "archiver/scraper"
require_relative "archiver/parser"
require_relative "archiver/exporter"

def archive!(refresh=false)
  scraper = Archiver::Scraper.new({ refresh: refresh })
  scraper.write!

  parser    = Archiver::Parser.new(scraper.data)
  exporter  = Archiver::Exporter.new(parser.normalized)

  exporter.write!
end
