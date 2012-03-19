module MovieTickets

  extend TicketSources::CountryMethods

  supports_country_codes 'US', 'CA'

  class << self

    def find_theaters_near(postal_code)
      TheaterSource.scour(postal_code).map do |theater_source|
        Geocoder.loop_on_query_limit_exception do
          theater_source.find_or_create!.theater
        end
      end
    end

    def diagnostics
      MovieTickets::TheaterSource.diagnostics
      MovieTickets::TheaterLocation.diagnostics
      MovieTickets::MovieSource.diagnostics
    end

  end

end
