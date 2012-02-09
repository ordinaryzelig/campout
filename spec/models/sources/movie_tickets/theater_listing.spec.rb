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

  describe '#find_or_create_movie_source!' do

    it 'returns the existing theater source if it already exists' do
      existing_theater_source = FactoryGirl.create(:movie_tickets_amc)
      listing = MovieTickets::TheaterListing.new(house_id: existing_theater_source.external_id)
      theater_source = listing.find_or_create_movie_source!
      theater_source.must_equal existing_theater_source
      MovieTickets::Theater.count.must_equal 1
    end

    it 'creates a new theater source for an existing theater' do
      theater = FactoryGirl.create(:amc)
      listing = MovieTickets::TheaterListing.new(house_id: 1, name: theater.name)
      theater_source = listing.find_or_create_movie_source!
      theater_source.theater.must_equal theater
      Theater.count.must_equal 1
      MovieTickets::Theater.count.must_equal 1
    end

  end

end
