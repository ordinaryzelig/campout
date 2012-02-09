require 'spec_helper'

describe MovieTickets::Theater do

  it 'scrapes titles' do
    VCR.use_cassette('movie_tickets/theaters/amc') do
      theater_source = FactoryGirl.build(:movie_tickets_amc)
      movies = MovieTickets::Theater.scour(
        theater_source: theater_source,
        date:           Date.new(2012, 1, 18),
      )
      movies.size.must_equal 29
      movie = movies.first
      movie.external_id.must_equal '110178'
    end
  end

end
