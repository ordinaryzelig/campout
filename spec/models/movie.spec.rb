require 'spec_helper'

describe Movie do

  it '.unreleased scopes movies whose released_on is later than today' do
    old_movie    = FactoryGirl.create(:movie, released_on: Date.current.yesterday, title: 'asdf')
    today_movie  = FactoryGirl.create(:movie, released_on: Date.current,           title: 'asdf')
    future_movie = FactoryGirl.create(:movie, released_on: Date.current.tomorrow,  title: 'asdf')
    Movie.unreleased.must_equal [future_movie]
  end

  it '.check_for_newly_released_tickets calls #check_for_tickets on each unreleased movie' do
    movie = FactoryGirl.build(:movie, released_on: Date.current.tomorrow)
    Movie.expects(:unreleased).returns([movie])
    Movie.any_instance.expects(:check_for_tickets)
    Movie.check_for_newly_released_tickets
  end

  describe '#check_for_tickets' do

    let(:movie)   { FactoryGirl.create(:iron_lady, released_on: Date.current.tomorrow) }
    let(:theater) { Theater.new(name: 'amc') }
    let(:account) { FactoryGirl.create(:redningja, zipcode: '12345', movies: [movie]) }

    before do
      disable_geocoding
      account()
    end

    it 'calls TicketSources.find_theaters_selling_at on each movie_source with account zipcode' do
      TicketSources.expects(:find_theaters_selling_at).with(movie, account.zipcode).returns([])
      movie.check_for_tickets
    end

    it 'notifies twitter account when theaters selling tickets' do
      TicketSources.expects(:find_theaters_selling_at).returns([theater])
      TwitterAccount.any_instance.expects(:theaters_not_tracking_for_movie).returns([])
      TwitterAccount.any_instance.expects(:notify_about_tickets!).with(movie, [theater])
      movie.check_for_tickets
    end

    it 'does not notify when no theaters selling tickets' do
      TicketSources.expects(:find_theaters_selling_at).returns([])
      TwitterAccount.any_instance.expects(:theaters_not_tracking_for_movie).returns([])
      TwitterAccount.any_instance.expects(:notify_about_tickets!).never
      movie.check_for_tickets
    end

    it 'does not notify when already notified about theater' do
      TicketSources.expects(:find_theaters_selling_at).returns([theater])
      TwitterAccount.any_instance.expects(:theaters_not_tracking_for_movie).returns([theater])
      TwitterAccount.any_instance.expects(:notify_about_tickets!).never
      movie.check_for_tickets
    end

    it 'returns array of accounts that were notified' do
      TicketSources.expects(:find_theaters_selling_at).returns([theater])
      TwitterAccount.any_instance.expects(:notify_about_tickets!)
      accounts = movie.check_for_tickets
      accounts.must_equal [account]
    end

    it 'only checks for TwitterAccounts that are trackable' do
      TwitterAccount.expects(:trackable).returns([])
      movie.check_for_tickets
    end

  end

end
