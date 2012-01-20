require 'spec_helper'

describe MovieTicketsMovie do

  it 'scrapes future titles' do
    date_test_run = Date.civil(2012, 1, 20)
    Timecop.freeze(date_test_run) do
      VCR.use_cassette('movie_tickets/movies/ghost_rider') do
        movie = FactoryGirl.build(:movie_tickets_ghost_rider)
        release_date = Date.civil(2012, 02, 16)
        theaters = MovieTicketsMovie.scour(
          movie: movie,
          zipcode: 10001,
        )
        theaters.size.must_equal 3
        theaters.first.name.must_equal 'AMC Aviation 12'
      end
    end
  end

end
