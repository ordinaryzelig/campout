# require each source.
Dir['./models/sources/*.rb'].each { |f| require f }
# require source dirs.
Dir['./models/sources/*/*.rb'].each { |f| require f }

module TicketSources
  class << self

    def all
      @all ||= [
        Fandango,
        MovieTickets
      ]
    end

    def find_theaters_near(postal_code)
      all.map { |source| source.find_theaters_near(postal_code) }.flatten.uniq
    end

    # For each movie_source, find_theaters_selling_at postal_code.
    # Return uniq list of theaters.
    def find_theaters_selling_at(movie, postal_code)
      movie.movie_sources.map do |movie_source|
        movie_source.find_theaters_selling_at(postal_code)
      end.flatten.uniq
    end

    def diagnostics
      all.each do |source|
        print "#{source.name}..."
        source.diagnostics
        puts 'OK'
      end
    end

  end
end
