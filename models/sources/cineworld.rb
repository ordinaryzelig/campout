module CineWorld

  extend TicketSources::CountryMethods

  supports_country_codes # UK, eventually.

  class << self

    def diagnostics
      print 'TODO...'
    end

    def find_theaters_near
      raise 'Not yet implemented'
    end

  end

end
