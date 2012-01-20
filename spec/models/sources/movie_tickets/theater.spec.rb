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

  describe '#find_or_create' do

    it 'returns persisted theater if it exists' do
      theater = FactoryGirl.create(:movie_tickets_amc)
      theater.find_or_create!
      MovieTicketsTheater.count.must_equal 1
    end

    it 'returns newly created theater if it is not persisted yet' do
      theater = FactoryGirl.build(:movie_tickets_amc)
      theater.find_or_create!
      theater.persisted?.must_equal true
    end

  end

end
