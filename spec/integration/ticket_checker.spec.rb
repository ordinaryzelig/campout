require 'spec_helper'

describe 'Ticket checking workflow' do

  before do
    disable_geocoding
  end

  scenario 'when user sends location' do
    it 'finds theaters nearby using all ticket sources' do
      # FIXME: This is cassette is big (almost 1MB).
      VCR.use_cassette 'all_theaters_near_73142' do
        stub_geocoder_with_counter
        account = FactoryGirl.build(:redningja)
        account.expects(:dm!)
        account.process_zipcode(73142)
        Theater.count.must_equal 23
        Fandango::TheaterSource.count.must_equal 11
        MovieTickets::TheaterSource.count.must_equal 12
      end
    end
  end

  it 'all ticket sources are checked for tickets' do
    date = Date.civil(2012, 1, 20)
    Timecop.freeze(date) do
      VCR.use_cassette 'check_for_tickets_for_ghost_rider_near_73142' do
        stub_geocoder_with_counter
        # Setup.
        movie = FactoryGirl.create(:ghost_rider, released_on: Date.current.tomorrow)
        account = FactoryGirl.create(:redningja, zipcode: 73142, movies: [movie])
        FactoryGirl.create(:movie_tickets_ghost_rider, movie: movie)
        FactoryGirl.create(:fandango_ghost_rider, movie: movie)
        TwitterAccount.any_instance.expects(:dm!)
        # The call.
        Movie.check_for_newly_released_tickets
      end
    end
  end

end
