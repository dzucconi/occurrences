require "logger"

module Archiver
  class Scraper
    attr_reader :agent, :urls, :refresh, :log

    def initialize(options={})
      options.reverse_merge!({
        refresh: false,
        urls: [
          "http://archive.newmuseum.org/index.php/Features/Show/displaySet?set_id=8",
          "http://archive.newmuseum.org/index.php/Features/Show/displaySet?set_id=9"
        ]
      })

      @agent    = Mechanize.new
      @refresh  = options[:refresh]
      @urls     = options[:urls]
      @log      = Logger.new(STDOUT)
    end

    def data
      @data ||= refresh ? scrape : cached
    end

    # Looks through an array of strings and returns anything that
    # matches the signature `/\/occurrence\_id\//`
    #
    # @params [Array]
    # @return [Array]
    def filter(_hrefs)
      _hrefs.select do |href|
        !href.match(/\/occurrence\_id\//).nil?
      end
    end

    # Given a Mechanize::Page array, extract out all the hrefs
    # and return a flat array of strings
    #
    # @params [Array]
    # @return [Array]
    def hrefs(_pages)
      _pages.
        collect(&:links).flatten.
        collect(&:href)
    end

    # Get title and date from a given page.
    # Blow up if we don't find it.
    #
    # @params [Mechanize::Page]
    # @return [Hash]
    def parse(page)
      date, title = page.search("#leftColNarrow .detailText").first.text,
                    page.search("#detailTitle").text.gsub("\"", "")

      raise Exception if [date, title].any?(&:nil?)

      { title: title, date: date }
    end

    # Accept a url, get the page, and pass it on to parsing
    #
    # @params [String] A valid URL
    # @return [Hash]
    def fetch_and_parse(url)
      begin
        logger.info("Getting: #{url} ...")

        page = agent.get(url)

        parse(page)
      rescue
        logger.warn("Failed: #{url}")

        { failure: true, url: url}
      end
    end

    def write!
      Exporter.new(data, { as: :rb }).write!
    end

  private

    # Load the data stored in data.rb
    def cached
      eval(File.open("./lib/data/data.rb").read)
    end

    # Reload all the data from the web
    def scrape(length=0)
      _hrefs  = hrefs(urls.map { |url| agent.get(url) })

      filter(_hrefs).truncate(length).collect { |url| fetch_and_parse(url) }
    end
  end # Scraper
end # Archiver
