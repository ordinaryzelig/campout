# Scouring a theater will return array of movies showing at that theater.

class MovieTicketsTheater < ActiveRecord::Base

  include HTTParty
  base_uri 'http://www.movietickets.com/house_detail.asp'

  validates :name, presence: true
  validates :house_id, numericality: {greater_than: 0}

  class << self

    # Check to see if movies are parsing correctly.
    def diagnostics
      theater = MovieTicketsTheater.first
      movies = scour theater: theater
      raise "No movies found at #{theater.name}" if movies.empty?
      movies
    end

    # Make request, parse, return movies.
    def scour(options)
      html = get '', query: query_options(options)
      parse html
    end

    private

    # Parse HTML into attributes and return Movie objects.
    def parse(html)
      doc = Nokogiri.HTML(html)
      movies = doc.css('#rw3 li').map do |li|
        # parse.
        title = li.css('h4 a').text
        # Skip if no title.
        next nil if title.blank?
        movie_id = li.css('h4 a').first['href'].match(/movie_id=(?<id>\d+)/)[:id]
        # Build new movie.
        movie = MovieTicketsMovie.new(
          title: title,
          movie_id: movie_id,
        )
      end
      movies.compact
    end

    # Construct options to use in HTTParty request query (i.e.g the ? part).
    # Options (required unless noted otherwise):
    #   theater: Converts to house_id
    #   date (optional)
    def query_options(options)
      options.each_with_object({}) do |(key, val), hash|
        case key
        when :date    then hash[:rdate]    = val.strftime('%D')
        when :theater then hash[:house_id] = val.house_id
        else
          raise "unknown option: #{key}"
        end
      end
    end

  end

end
