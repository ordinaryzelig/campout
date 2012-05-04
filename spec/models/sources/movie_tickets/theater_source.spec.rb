require 'spec_helper'

describe MovieTickets::TheaterSource do

  it_must_behave_like_theater_source

  describe '.scour' do

    it 'searches site for location, determines postal_code, and parses and creates theaters' do
      VCR.use_cassette('movie_tickets/theaters/search_location_73142') do
        list = MovieTickets::TheaterSource.scour(73142, 'US')
        list.size.must_equal 12
        listing = list.first
        listing.theater.name.must_equal 'AMC Quail Springs Mall 24'
        listing.external_id.must_equal '5902'
      end
    end

    it 'includes theaters that site does not sell tickets for' do
      VCR.use_cassette('movie_tickets/theaters/search_location_92010') do
        list = MovieTickets::TheaterSource.scour(92010, 'US')
        list.size.must_equal 11
        regal_oceanside = MovieTickets::TheaterSource.new(external_id: '6933')
        list.map(&:external_id).must_include regal_oceanside.external_id
      end
    end

    describe 'by country' do

      it 'searches UK site' do
        VCR.use_cassette('movie_tickets/theaters/search_location_SE18XR') do
          list = MovieTickets::TheaterSource.scour('SE1 8XR', 'GB')
          list.size.must_equal 125
          theater_source = list.first
          theater_source.theater.name.must_equal 'Showcase Cinemas Newham'
          theater_source.external_id.must_equal  '8507'
        end
      end

      it 'searches Ireland site' do
        VCR.use_cassette('movie_tickets/theaters/search_location_Dublin') do
          list = MovieTickets::TheaterSource.scour('Dublin', 'IE')
          list.size.must_equal 20
          theater_source = list.first
          theater_source.theater.name.must_equal 'Quayside Cinema Balbriggan'
          theater_source.external_id.must_equal  '10306'
        end
      end

    end

  end

  describe '#find_or_create!' do

    let(:theater_source) { theater_source = MovieTickets::TheaterSource.new(external_id: 1) }

    it 'finds existing theater sources by external_id' do
      existing = FactoryGirl.create(:movie_tickets_amc, external_id: theater_source.external_id)
      theater_source.find_or_create!.must_equal(existing)
      MovieTickets::TheaterSource.count.must_equal 1
    end

    it 'creates new theater source if it does not exist' do
      MovieTickets::TheaterSource.count.must_equal 0
      theater = FactoryGirl.build(:amc, id: 1)
      location = FactoryGirl.build(:movie_tickets_amc_location)
      location.stubs(:find_or_create_theater).returns(theater)
      theater_source.expects(:location).returns(location)
      theater_source.find_or_create!
      MovieTickets::TheaterSource.count.must_equal 1
    end

  end

  it 'has language for every supported country code' do
    language_countries = MovieTickets::TheaterSource::LANGUAGES
    MovieTickets.country_codes.each do |country_code|
      language_countries.must_include country_code
    end
  end

end
