class MovieTickets::MovieSource < MovieSource

  include HTTParty
  base_uri 'http://www.movietickets.com/movie_detail.asp'

  class << self

    # Make request, parse, return TheaterSources.
    def scour(options)
      html = get '', query: query_options(options)
      parse html
    end

    # Get first movie from AMC Quail.
    # Make sure it's selling tickets there.
    def diagnostics
      theater_location = MovieTickets::TheaterLocation.scour(5902, true)
      movie_id = theater_location.first_movie_id
      theater_sources = MovieTickets::MovieSource.scour(zipcode: 73142, date: Date.current, movie_id: movie_id)
      raise "AMC not selling #{movie_id}" unless theater_sources.map(&:external_id).include?('5902')
    end

    private

    # Parse HTML into attributes and return TheaterSource objects.
    def parse(html)
      doc = Nokogiri.HTML(html)
      theaters = doc.css('#mdRow1 li').map do |li|
        name = li.css('a strong').text
        next if name.blank?
        house_id = li.css('a').first['href'].match(/house_id=(?<id>\d+)/)[:id]
        MovieTickets::TheaterSource.new(
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
        when :movie_id
          hash[:movie_id] = val
        when :movie_source
          # Set both movie_id and ShowDate.
          movie_source = val
          hash.merge! query_options(movie_id: movie_source.external_id)
          hash.merge! query_options(date: movie_source.released_on) if movie_source.released_on
        when :zipcode
          hash[:SearchZip] = val
        else
          raise "unknown option: #{key}"
        end
      end
    end

  end

  def find_theaters_selling_at(zipcode)
    theater_sources = self.class.scour(
      movie_source: self,
      zipcode:      zipcode,
    )
    theater_sources.map!(&:find_or_create!)
    theater_sources.map(&:theater)
  end

end
