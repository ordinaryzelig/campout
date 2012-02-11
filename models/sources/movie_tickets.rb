module MovieTickets

  class << self

    def find_theaters_near(zipcode)
      TheaterSource.scour(zipcode)
    end

  end

end
