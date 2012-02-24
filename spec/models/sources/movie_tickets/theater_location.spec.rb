# encoding: utf-8
# For multi-byte chars.

require 'spec_helper'

describe MovieTickets::TheaterLocation do

  it '.scour returns TheaterLocation object with address and coordinates' do
    VCR.use_cassette 'movie_tickets/theater_location_amc' do
      MovieTickets::TheaterLocation.any_instance.expects(:geocode)
      loc = MovieTickets::TheaterLocation.scour(5902)
      loc.name.must_equal    'AMC Quail Springs Mall 24'
      loc.address.must_equal '2501 West Memorial, Oklahoma City, OK 73134' # The space after 'OK' is a multi-byte char &nbsp;.
    end
  end

  it 'uses Geocoder to obtain coordinates based on address' do
    VCR.use_cassette 'geocoder/amc' do
      loc = MovieTickets::TheaterLocation.new(address: '2501 West Memorial, Oklahoma City, OK 73134')
      loc.geocode
      loc.latitude.must_equal  35.612151
      loc.longitude.must_equal -97.56118900000001
    end
  end

  describe '#find_or_create_theater!' do

    let(:theater_location) { FactoryGirl.build(:movie_tickets_amc_location) }

    it 'finds existing theater based on location' do
      theater = FactoryGirl.create(:amc)
      theater_location.find_or_create_theater!.must_equal theater
      Theater.count.must_equal 1
    end

    it 'creates new theater based on location if it does not exist' do
      Theater.count.must_equal 0
      theater_location.find_or_create_theater!
      Theater.count.must_equal 1
    end

  end

end
