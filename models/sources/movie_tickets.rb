module MovieTickets

  class << self

    def find_theaters_near(zipcode)
      TheaterSource.scour(zipcode).map do |theater_source|
        theater_source.find_or_create!.theater
      end
    end

    def diagnostics
      MovieTickets::TheaterSource.diagnostics
      MovieTickets::TheaterLocation.diagnostics
      MovieTickets::MovieSource.diagnostics
    end

  end

end
