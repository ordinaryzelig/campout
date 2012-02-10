require 'spec_helper'

describe Movie do

  it '.unreleased scopes movies whose released_on is later than today' do
    old_movie    = FactoryGirl.create(:movie, released_on: Date.yesterday, title: 'asdf')
    today_movie  = FactoryGirl.create(:movie, released_on: Date.today,     title: 'asdf')
    future_movie = FactoryGirl.create(:movie, released_on: Date.tomorrow,  title: 'asdf')
    Movie.unreleased.must_equal [future_movie]
  end

  it '.check_for_newly_released_tickets calls #check_for_tickets on each unreleased movie' do
    movie = FactoryGirl.build(:movie, released_on: Date.tomorrow)
    Movie.expects(:unreleased).returns([movie])
    Movie.any_instance.expects(:check_for_tickets)
    Movie.check_for_newly_released_tickets
  end

  describe '#find_theaters_selling_at' do

    let(:movie)   { FactoryGirl.build(:iron_lady, released_on: Date.tomorrow) }

    before do
      movie_sources = [mock, mock]
      movie_sources.each do |movie_source|
        movie_source.expects(:find_theaters_selling_at).returns([1])
      end
      movie.stubs(:movie_sources).returns(movie_sources)
    end

    it 'calls #find_theaters_selling_at on each movie_source' do
      # Expectations setup in before block.
      movie.find_theaters_selling_at('zipcode')
    end

    it 'returns an array with uniq theaters' do
      theaters = movie.find_theaters_selling_at('zipcode')
      theaters.must_equal [1]
    end

  end

  describe '#check_for_tickets' do

    let(:movie)   { FactoryGirl.create(:iron_lady, released_on: Date.tomorrow) }
    let(:theater) { Theater.new(name: 'amc') }
    let(:account) { FactoryGirl.create(:redningja, zipcode: '12345', movies: [movie]) }

    before do
      account()
    end

    it 'finds theaters selling movie near each TwitterAccount postal code' do
      movie.expects(:find_theaters_selling_at).with(account.zipcode).returns([])
      movie.check_for_tickets
    end

    it 'notifies twitter account when theaters selling tickets' do
      movie.expects(:find_theaters_selling_at).returns([theater])
      TwitterAccount.any_instance.expects(:theaters_not_tracking_for_movie).returns([])
      TwitterAccount.any_instance.expects(:notify_about_tickets!).with(movie, [theater])
      movie.check_for_tickets
    end

    it 'does not notify when no theaters selling tickets' do
      movie.expects(:find_theaters_selling_at).returns([])
      TwitterAccount.any_instance.expects(:theaters_not_tracking_for_movie).returns([])
      TwitterAccount.any_instance.expects(:notify_about_tickets!).never
      movie.check_for_tickets
    end

    it 'does not notify when already notified about theater' do
      movie.expects(:find_theaters_selling_at).returns([theater])
      TwitterAccount.any_instance.expects(:theaters_not_tracking_for_movie).returns([theater])
      TwitterAccount.any_instance.expects(:notify_about_tickets!).never
      movie.check_for_tickets
    end

    it 'returns array of accounts that were notified' do
      movie.expects(:find_theaters_selling_at).returns([theater])
      TwitterAccount.any_instance.expects(:notify_about_tickets!)
      accounts = movie.check_for_tickets
      accounts.must_equal [account]
    end

  end

end
