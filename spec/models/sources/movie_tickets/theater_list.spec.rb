require 'spec_helper'

describe MovieTicketsTheaterList do

  describe '.scour' do

    it 'searches site for location, determines zipcode, and parses and creates theaters' do
      VCR.use_cassette('movie_tickets/theaters/search_location_73142') do
        theaters = MovieTicketsTheaterList.scour(73142)
        theaters.size.must_equal 12
        theater = theaters.first
        theater.name.must_equal 'AMC Quail Springs Mall 24'
        theater.house_id.must_equal 5902
      end
    end

    it 'includes theaters that site does not sell tickets for' do
      VCR.use_cassette('movie_tickets/theaters/search_location_92010') do
        theaters = MovieTicketsTheaterList.scour(92010)
        theaters.size.must_equal 10
        regal_oceanside = MovieTicketsTheater.new(house_id: 6933)
        theaters.map(&:house_id).must_include regal_oceanside.house_id
      end
    end

  end

end
