require 'spec_helper'

describe MovieTickets do

  it_must_behave_like_ticket_source

  describe '.find_theaters_near' do

    it 'uses .scour to find or create theater_sources and theaters, returns theaters' do
      theater_source = FactoryGirl.build(:movie_tickets_amc)
      MovieTickets::TheaterSource.expects(:scour).returns([theater_source])
      MovieTickets::TheaterSource.any_instance.expects(:find_or_create!).returns(theater_source)
      theaters = MovieTickets.find_theaters_near(1)
      theaters.first.must_be_kind_of Theater
    end

  end

end
