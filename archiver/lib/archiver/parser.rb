module Archiver
  class Parser
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def occurrences
      @occurrences ||= data.reject { |hsh| hsh.has_key?(:failure) }
    end

    def normalized
      @normalized ||= occurrences.collect { |hsh| normalize(hsh) }
    end

    def normalize(hsh)
      dates =
        normalize_date_pair(split_date(hsh[:date])).
          map { |date| Chronic.parse(date) }

      a, b = dates.first, dates.last # Will be identical if a single day event
      c    = (a && b ? (a.to_datetime + ((b.to_datetime - a.to_datetime).to_i / 2)) : dates.first)

      a, b, c = [a, b, c].map { |x| x.strftime("%F") }

      hsh.merge({ start: a, end: b, mid: c })
    end

    # Examples:
    # => "January 12 2013"
    # => "January 18 2013 at 19:00"
    # => "March 8 - March 9 2012"
    # => "October 27 2000 - January 21 2001"
    # => "after May 3 2001"
    # => "October 13 2012 at 15:00 - 16:00"
    # => "2002"
    def split_date(string)
      case string
        # Check for the presence of "at" first
        when /\sat\s/
          [string.split(" at ").first] # Discard time
        when /\s-\s/
          string.split(" - ")
        when /^after /
          [string.gsub("after", "").strip]
        else # Always return Array
          [string]
      end
    end

    def bare_year?(string)
      string =~ /(^\d{4}$)/
    end

    def full_year?(pair)
      pair.size == 1 && bare_year?(pair.first)
    end

    def full_year!(pair)
      ["January 1 #{pair.first}", "December 31 #{pair.first}"]
    end

    # Accepts an Array of strings, and gets a single year from the pair
    # Maps over the array and if the item has a year already; leave it alone
    # If not then assume it's the year we've parsed out
    def normalize_date_pair(pair)
      pair = full_year!(pair) if full_year?(pair)

      year = pair.map do |x|
        x.match(/\d{4}/).to_s
      end.reject(&:empty?).first

      pair.map do |x|
        x =~ /\d{4}/ ? x : "#{x} #{year}"
      end
    end
  end # Parser
end # Archiver
