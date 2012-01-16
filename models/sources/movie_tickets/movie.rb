# Scouring a movie will return array of theaters showing that movie.

module MovieTickets
  class Movie < ::Movie

    include HTTParty
    base_uri 'http://www.movietickets.com/movie_detail.asp'
    default_params(
      SearchRadius: 40, # miles.
    )

    def on_sale_at_theaters(date, zipcode)
      self.class.scour(
        movie:   self,
        date:    date,
        zipcode: zipcode,
      )
    end

    class << self

      def search(pattern)
        all.detect { |movie| movie.title =~ Regexp.new(pattern, 'i') }
      end

      private

      # Parse HTML into attributes and return Theater objects.
      def parse(html)
        doc = Nokogiri.HTML(html)
        theaters = doc.css('#mdRow1 li').map do |li|
          Theater.new(
            name: li.css('a strong').text,
          )
        end
        # Return only theaters with a title.
        theaters.select { |theater| theater.name != '' }
      end

      # Construct options to use in HTTParty request query (i.e.g the ? part).
      # Options:
      #   zipcode
      #   movie: Converts to movie_id.
      #   date (optional):  They do a countup style here. E.g. x days from today.
      def query_options(options)
        options.each_with_object({}) do |(key, val), hash|
          case key
          when :date    then hash[:ShowDate]  = Date.today - val
          when :movie   then hash[:movie_id]  = val.id
          when :zipcode then hash[:SearchZip] = val
          else
            raise "unknown option: #{key}"
          end
        end
      end

    end

  end
end
