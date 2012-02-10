require 'spec_helper'

describe MovieTickets::TheaterListing do

  describe '.scour' do

    it 'searches site for location, determines zipcode, and parses and creates theaters' do
      VCR.use_cassette('movie_tickets/theaters/search_location_73142') do
        list = MovieTickets::TheaterListing.scour(73142)
        list.size.must_equal 12
        listing = list.first
        listing.name.must_equal 'AMC Quail Springs Mall 24'
        listing.house_id.must_equal '5902'
      end
    end

    it 'includes theaters that site does not sell tickets for' do
      VCR.use_cassette('movie_tickets/theaters/search_location_92010') do
        list = MovieTickets::TheaterListing.scour(92010)
        list.size.must_equal 10
        regal_oceanside = MovieTickets::TheaterListing.new(house_id: '6933')
        list.map(&:house_id).must_include regal_oceanside.house_id
      end
    end

  end

end
