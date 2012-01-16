require 'spec_helper'

describe MovieTickets::Theater do

  it 'scrapes titles' do
    VCR.use_cassette('movietickets/theaters/amc') do
      movies = MovieTickets::Theater.scour(
        theater: MovieTickets::Theater.first,
        date:    Date.new(2012, 01, 16),
      )
      movies.size.must_equal 28
      movies.first.title.must_equal 'The Adventures of Tintin 3D'
    end
  end

end
