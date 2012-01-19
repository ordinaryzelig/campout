require 'spec_helper'

describe MovieTicketsTheaterList do

  it '.scour searches site for location, determines zipcode, and parses and creates theaters' do
    VCR.use_cassette('movie_tickets/theaters/search_location_73142') do
      theaters = MovieTicketsTheaterList.scour(73142)
      theaters.size.must_equal 6
      theater = theaters.first
      theater.name.must_equal 'AMC Quail Springs Mall 24'
      theater.house_id.must_equal 5902
    end
  end

end
