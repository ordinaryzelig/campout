module TicketSources

  class << self

    def for_country(country_code)
      Scope.new(country_code)
    end

    def diagnostics
      all.each do |source|
        print "#{source.name}..."
        source.diagnostics
        puts 'OK'
      end
    end

  end

  # Kind of like ActiveRecord::Scope.
  # Returned from TicketSources.for_country.
  class Scope

    def initialize(country_code)
      @country_code = country_code
    end

    def all
      @all ||= [
        CineWorld,
        Fandango,
        MovieTickets
      ].select { |ticket_source| @country_code == :all ? true : ticket_source.serves_country_code?(@country_code) }
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

  end

  module CountryMethods

    def serves_country_code?(country_code)
      @country_codes.include?(country_code)
    end

    # Define list of country codes this ticket source serves.
    def serves_country_codes(*country_codes)
      @country_codes = country_codes
    end

  end

end

# require each source.
Dir['./models/sources/*.rb'].each { |f| require f }
# require source dirs.
Dir['./models/sources/*/*.rb'].each { |f| require f }
