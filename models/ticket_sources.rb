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

  end
end
