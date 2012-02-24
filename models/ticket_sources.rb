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

    def find_theaters_near(zipcode)
      all.map { |source| source.find_theaters_near(zipcode) }.flatten.uniq
    end

    # For each movie_source, find_theaters_selling_at zipcode.
    # Return uniq list of theaters.
    def find_theaters_selling_at(movie, zipcode)
      movie.movie_sources.map do |movie_source|
        movie_source.find_theaters_selling_at(zipcode)
      end.flatten.uniq
    end

  end
end
