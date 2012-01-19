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
      movies.first.title.must_equal 'The Adventures of Tintin 3D'
    end
  end

end
