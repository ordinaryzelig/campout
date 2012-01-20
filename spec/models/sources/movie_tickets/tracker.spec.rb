require 'spec_helper'

describe MovieTicketsTracker do

  let(:account) { FactoryGirl.create(:redningja) }
  let(:theater) { FactoryGirl.create(:movie_tickets_amc) }
  let(:movie)   { FactoryGirl.create(:movie_tickets_iron_lady) }

  describe 'gets created' do

    it 'for each theater when movie assignment is created' do
      # Reverse order of test below.
      account.movie_tickets_theaters << theater
      account.movie_tickets_movies << movie
    end

    it 'for each movie when theater assignment is created' do
      # Reverse order of test above.
      account.movie_tickets_movies << movie
      account.movie_tickets_theaters << theater
    end

    # The assertions are the same.
    after do
      tracker = MovieTicketsTracker.first
      tracker.twitter_account.must_equal account
      tracker.movie_tickets_movie.must_equal movie
      tracker.movie_tickets_theater.must_equal theater
    end

  end

  describe 'gets destroyed' do

    before do
      account.movie_tickets_theaters << theater
      account.movie_tickets_movies << movie
    end

    it 'when the movie assignment is destroyed' do
      account.movie_tickets_movie_assignments.clear
      MovieTicketsTracker.count.must_equal 0
    end

    it 'when the theater assignment is destroyed' do
      account.movie_tickets_theater_assignments.clear
      MovieTicketsTracker.count.must_equal 0
    end

  end

end
