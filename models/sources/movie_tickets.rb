module MovieTickets

  class << self

    def find_theaters_near(zipcode)
      TheaterListing.scour(zipcode)
    end

  end

end
