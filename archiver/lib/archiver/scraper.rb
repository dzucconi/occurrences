module Archiver
  class Scraper
    BASE  = "http://archive.newmuseum.org"
    URL   = "#{BASE}/index.php/Features/Show/displaySet?set_id="
    IDS   = [8, 9]
    AGENT = Mechanize.new

    class << self
      def data(options={})
        options.reverse_merge!({ refresh: false })

        @data ||=
          unless options[:refresh]
            eval(File.open("./lib/data/data.rb").read)
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
    end # self
  end # Scraper
end # Archiver
