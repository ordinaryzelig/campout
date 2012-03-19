module CineWorld

  extend TicketSources::CountryMethods

  serves_country_codes 'UK'

  class << self

    def diagnostics
      print 'TODO...'
    end

    def find_theaters_near
      raise 'Not yet implemented'
    end

  end

end
