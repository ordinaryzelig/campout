class MovieTickets::Movie < MovieSource

  include HTTParty
  base_uri 'http://www.movietickets.com/movie_detail.asp'

  class << self

    # Check to see if theaters are parsing correctly.
    def diagnostics(movie)
      theaters = scour(movie: movie, zipcode: 73142)
      raise "No theaters found for #{movie.title}" if theaters.empty?
      theaters
    end

    # Make request, parse, return theaters.
    def scour(options)
      html = get '', query: query_options(options)
      parse html
    end

    private

    # Parse HTML into attributes and return Theater objects.
    def parse(html)
      doc = Nokogiri.HTML(html)
      theaters = doc.css('#mdRow1 li').map do |li|
        name = li.css('a strong').text
        next if name.blank?
        house_id = li.css('a').first['href'].match(/house_id=(?<id>\d+)/)[:id]
        Theater.new(
          external_id: house_id,
        )
      end.compact
      theaters
    end

    # Construct options to use in HTTParty request query (i.e.g the ? part).
    # Options:
    #   zipcode
    #   movie_source: Converts to movie_id usin external_id and ShowDate using movie.released_on.
    def query_options(options)
      options.each_with_object({}) do |(key, val), hash|
        case key
        when :date
          hash[:ShowDate] = val.to_ShowDate
        when :movie_source
          # Set both movie_id and ShowDate.
          movie_source = val
          hash[:movie_id]  = movie_source.external_id
          hash[:ShowDate]  = movie_source.released_on.to_ShowDate if movie_source.released_on
        when :zipcode
          hash[:SearchZip] = val
        else
          raise "unknown option: #{key}"
        end
      end
    end

  end

  def find_theaters_selling_at(zipcode)
    self.class.scour(
      movie_source: self,
      zipcode:      zipcode,
    )
  end

end
