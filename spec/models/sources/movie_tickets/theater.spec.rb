require 'spec_helper'

describe MovieTicketsTheater do

  it 'scrapes titles' do
    VCR.use_cassette('movie_tickets/theaters/amc') do
      FactoryGirl.create(:movie_tickets_amc)
      movies = MovieTicketsTheater.scour(
        theater: MovieTicketsTheater.first,
        date:    Date.new(2012, 1, 18),
      )
      movies.size.must_equal 29
      movie = movies.first
      movie.title.must_equal 'The Adventures of Tintin 3D'
      movie.movie_id.must_equal 110178
    end
  end

end
