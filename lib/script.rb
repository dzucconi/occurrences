require "mechanize"
require "chronic"
require "oj"

class Object
  def try(*a, &b)
    if a.empty? && block_given?
      yield self
    else
      __send__(*a, &b)
    end
  end
end

class Hash
  def reverse_merge!(other_hash)
    merge!(other_hash){ |key, left, right| left }
  end
end

class Time
  def to_datetime
    # Convert seconds + microseconds into a fractional number of seconds
    seconds = sec + Rational(usec, 10**6)

    # Convert a UTC offset measured in minutes to one measured in a
    # fraction of a day.
    offset = Rational(utc_offset, 60 * 60 * 24)
    DateTime.new(year, month, day, hour, min, seconds, offset)
  end
end

module Scraper
  class Archiver
    BASE  = "http://archive.newmuseum.org"
    URL   = "#{BASE}/index.php/Features/Show/displaySet?set_id="
    IDS   = [8, 9]
    AGENT = Mechanize.new

    class << self
      def data(options={})
        options.reverse_merge!({ refresh: false })

        @data ||=
          unless options[:refresh]
            eval(File.open("./data/data.rb").read)
          else
            IDS.
              map { |id| AGENT.get(url + id.to_s) }.

              collect(&:links).flatten.
              collect(&:href).

              # Select only the links whose href matches the signature `/\/occurrence\_id\//`
              select { |href| !href.match(/\/occurrence\_id\//).nil? }.

              # Iterate through these links getting the date and title of each occurrence
              collect do |url|
                begin
                  puts "Getting: #{url} ..."
                  page = AGENT.get(url)

                  date, title = page.search("#leftColNarrow .detailText").first.text,
                                page.search("#detailTitle").text.gsub("\"", "")

                  puts "#{title}: #{date}"

                  { title: title, date: date }
                rescue
                  { failure: true, url: url}
                end
              end
          end
      end

      def occurrences
        @occurrences ||= data.reject { |hsh| hsh.has_key?(:failure) }
      end

      def normalized
        @normalized ||=
          occurrences.collect do |hsh|
            dates =
              normalize_date_pair(hsh[:date].
                split(" - ")).
                map { |date| Chronic.parse(date) }

            a, b = dates.first, dates.last
            c    = (a && b ? (a.to_datetime + ((b.to_datetime - a.to_datetime).to_i / 2)) : dates.first)

            puts "#{hsh[:title]}: #{a} #{b} #{c}"
            unless [a, b, c].all?(&:nil?)
              puts "OK"
              [a, b, c].map! { |x| x.strftime("%F") }
              puts "----"
            end

            hsh.merge({ start: a, end: b, mid: c })
          end
      end

      def to_json
        Oj.dump(normalized)
      end

      def write!
        File.open("./data/data.json", "w") { |f| f.write(to_json) }
      end

    private

      def normalize_date_pair(pair)
        year =
          pair.
            collect { |s| s.match(/\d\d\d\d/).to_s }.
            reject(&:empty?).
            first

        pair.collect do |s|
          s =~ /\d\d\d\d/ ? s : "#{s} #{year}"
        end
      end
    end # self
  end # Archiver
end # Scraper

# File.open("./tmp/") { |f| f.write(data) }

# ending_dates =
#   data.collect do |exhibition|
#     Chronic.parse(exhibition[1].split(" - ").pop)
#   end

# xxith_links =
#   ending_dates.collect do |date|
#     "http://xxith.com/?year=#{date.year}&month=#{date.strftime("%B")}&day=#{date.day}"
#   end
