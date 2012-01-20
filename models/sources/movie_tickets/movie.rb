# Scouring a movie will return array of theaters showing that movie.

class MovieTicketsMovie < ActiveRecord::Base

  validates :movie_id,    presence: true, uniqueness: true
  validates :title,       presence: true
  validates :released_on, presence: true

  include HTTParty
  base_uri 'http://www.movietickets.com/movie_detail.asp'

  def find_theaters_selling(zipcode)
    self.class.scour(
      movie:   self,
      zipcode: zipcode,
    )
  end

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
        MovieTicketsTheater.new(
          name: li.css('a strong').text,
        )
      end
      # Return only theaters with a name.
      theaters.select { |theater| theater.name.present? }
    end

    # Construct options to use in HTTParty request query (i.e.g the ? part).
    # Options:
    #   zipcode
    #   movie: Converts to movie_id and ShowDate.
    def query_options(options)
      options.each_with_object({}) do |(key, val), hash|
        case key
        when :date
          hash[:ShowDate] = val.to_ShowDate
        when :movie
          # Set both movie_id and ShowDate.
          movie = val
          hash[:movie_id]  = movie.movie_id
          hash[:ShowDate]  = movie.released_on.to_ShowDate if movie.released_on
        when :zipcode
          hash[:SearchZip] = val
        else
          raise "unknown option: #{key}"
        end
      end
    end

  end

end
