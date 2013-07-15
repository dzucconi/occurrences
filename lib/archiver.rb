lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "mechanize"
require "chronic"
require "oj"

require "core_ext/hash"
require "core_ext/object"
require "core_ext/time"

require "archiver/scraper"
require "archiver/parser"
require "archiver/exporter"

def archive!
  parser    = Archiver::Parser.new(Archiver::Scraper.data)
  exporter  = Archiver::Exporter.new(parser.normalized)

  exporter.write!
end
