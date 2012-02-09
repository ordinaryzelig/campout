require 'spec_helper'

describe Tracker do

  let(:account) { FactoryGirl.create(:redningja) }
  let(:theater) { FactoryGirl.create(:amc) }
  let(:movie)   { FactoryGirl.create(:iron_lady) }

  describe 'gets created' do

    it 'for each theater when movie assignment is created' do
      # Reverse order of test below.
      account.theaters << theater
      account.movies << movie
      # assertion in after block.
    end

    it 'for each movie when theater assignment is created' do
      # Reverse order of test above.
      account.movies << movie
      account.theaters << theater
      # assertion in after block.
    end

    # The assertions are the same.
    after do
      tracker = Tracker.first
      tracker.twitter_account.must_equal account
      tracker.movie.must_equal movie
      tracker.theater.must_equal theater
    end

  end

  describe 'gets destroyed' do

    before do
      account.theaters << theater
      account.movies << movie
    end

    it 'when the movie assignment is destroyed' do
      account.movie_assignments.clear
      Tracker.count.must_equal 0
    end

    it 'when the theater assignment is destroyed' do
      account.theater_assignments.clear
      Tracker.count.must_equal 0
    end

  end

end
