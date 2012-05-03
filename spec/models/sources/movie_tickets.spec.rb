require 'spec_helper'

describe MovieTickets do

  it_must_behave_like_ticket_source

  describe '.find_theaters_near' do

    it 'uses .scour to find or create theater_sources and theaters, returns theaters' do
      postal_code = 1
      country_code = 'US'
      theater_source = FactoryGirl.build(:movie_tickets_amc)
      MovieTickets::TheaterSource.expects(:scour).with(postal_code, country_code).returns([theater_source])
      MovieTickets::TheaterSource.any_instance.expects(:find_or_create!).returns(theater_source)
      theaters = MovieTickets.find_theaters_near(postal_code, country_code)
      theaters.first.must_be_kind_of Theater
    end

  end

  it 'supports country codes' do
    ['US', 'CA', 'IE', 'GB'].each do |country_code|
      MovieTickets.supports_country_code?(country_code).must_equal true
    end
  end

end
