require 'spec_helper'

describe 'Ticket checking workflow' do

  before do
    # Stub geocoder with incremental coordinates.
    Geocoder.stubs(:search).returns(*100.times.map do |i|
      [mock_geocoder_search_result(i, i, 'US', nil)]
    end)
  end

  scenario 'when user sends location' do
    it 'finds theaters nearby using all ticket sources' do
      # FIXME: This is cassette is big (almost 1MB).
      VCR.use_cassette 'all_theaters_near_73142' do
        account = FactoryGirl.build(:redningja)
        account.expects(:dm!)
        account.process_postal_code(73142)
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
        # Setup.
        movie = FactoryGirl.create(:ghost_rider, released_on: Date.current.tomorrow)
        account = FactoryGirl.create(:redningja, postal_code: 73142, movies: [movie])
        FactoryGirl.create(:movie_tickets_ghost_rider, movie: movie)
        FactoryGirl.create(:fandango_ghost_rider, movie: movie)
        TwitterAccount.any_instance.expects(:dm!)
        # The call.
        Movie.check_for_newly_released_tickets
      end
    end
  end

end
