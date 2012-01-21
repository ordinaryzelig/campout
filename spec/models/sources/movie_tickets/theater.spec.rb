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

  it '.tracked_by_multiples includes theaters that are being tracked by multiple accounts' do
    theater = FactoryGirl.create(:movie_tickets_amc)
    account = FactoryGirl.create(:redningja, movie_tickets_theaters: [theater])
    MovieTicketsTheater.tracked_by_multiples.all.size.must_equal 0
    account = FactoryGirl.create(:twitter_account, user_id: 1, screen_name: 'asdf', movie_tickets_theaters: [theater])
    MovieTicketsTheater.tracked_by_multiples.all.size.must_equal 1
  end

  it '#short_name removes the word "theater" and "theatre" and any trailing numbers to save character space' do
    name = 'fancy  schmancy theater theatre 64'
    theater = MovieTicketsTheater.new(name: name)
    theater.valid?
    theater.short_name.must_equal 'fancy schmancy'
  end

  it 'is compared to other theaters by house_id' do
    theater_1 = MovieTicketsTheater.new house_id: 1
    theater_2 = MovieTicketsTheater.new house_id: 1
    theater_1.must_equal theater_2
    [theater_1].must_include theater_2
  end

end
