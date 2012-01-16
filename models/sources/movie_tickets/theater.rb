# Scouring a theater will return array of movies showing at that theater.

module MovieTickets
  class Theater < ::Theater

    include HTTParty

    base_uri 'http://www.movietickets.com/house_detail.asp'

    class << self

      # Parse HTML into attributes and return Movie object.
      def parse(html)
        doc = Nokogiri.HTML(html)
        movies = doc.css('#rw3 li').map do |li|
          movie = Movie.new(
            title: li.css('h4 a').text,
          )
        end
        # Return only movies with a title.
        movies.select { |movie| movie.title != '' }
      end

      # Check to see if movies are parsing correctly.
      def diagnostics
        movies = scour theater: Theater.first
        raise "No movies found at #{url}" if movies.empty?
      end

      # Make request, parse, return movies.
      def scour(options)
        html = get '', query: query_options(options)
        parse html
      end

      private

      # Construct options to use in HTTParty request query (i.e.g the ? part).
      # Possible options:
      #   theater: Converts to house_id
      #   date
      def query_options(options)
        options.each_with_object({}) do |(key, val), hash|
          case key
          when :theater then hash[:house_id] = val.id
          when :date    then hash[:rdate] =    val.strftime('%D')
          else
            raise "unknown option: #{key}"
          end
        end
      end

    end

  end
end
