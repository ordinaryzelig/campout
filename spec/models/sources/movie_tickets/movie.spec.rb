require 'spec_helper'

describe MovieTicketsMovie do

  let(:movie)   { FactoryGirl.build(:movie_tickets_ghost_rider) }
  let(:theater) { FactoryGirl.create(:movie_tickets_amc) }
  let(:account) { FactoryGirl.create(:redningja, movie_tickets_movies: [movie], movie_tickets_theaters: [theater]) }

  it 'scrapes future titles' do
    date_test_run = Date.civil(2012, 1, 20)
    Timecop.freeze(date_test_run) do
      VCR.use_cassette('movie_tickets/movies/ghost_rider') do
        release_date = Date.civil(2012, 02, 16)
        theaters = MovieTicketsMovie.scour(
          movie: movie,
          zipcode: 10001,
        )
        theaters.size.must_equal 3
        theater = theaters.first
        theater.name.must_equal 'AMC Aviation 12'
        theater.house_id.must_equal 10513
      end
    end
  end

  it '.unreleased scopes movies whose released_on is later than today' do
    old_movie    = FactoryGirl.create(:movie_tickets_movie, released_on: Date.today - 1, title: 'asdf', movie_id: 1)
    today_movie  = FactoryGirl.create(:movie_tickets_movie, released_on: Date.today,     title: 'asdf', movie_id: 2)
    future_movie = FactoryGirl.create(:movie_tickets_movie, released_on: Date.today + 1, title: 'asdf', movie_id: 3)
    MovieTicketsMovie.unreleased.must_equal [future_movie]
  end

  it '.check_for_newly_released_tickets uses live trackers and twitter accounts zipcodes to call #find_theaters_selling_at' do
    MovieTicketsMovie.any_instance.expects(:find_theaters_selling_at).with(account.zipcode).once.returns([])
    MovieTicketsMovie.check_for_newly_released_tickets
  end

  describe '#check_for_tickets' do

    before do
      account()
    end

    it 'notifies twitter account when theaters selling tickets' do
      movie.expects(:find_theaters_selling_at).returns([theater])
      TwitterAccount.any_instance.expects(:notify_about_tickets!).with(account.movie_tickets_trackers)
      movie.check_for_tickets
    end

    it 'does not notify when no theaters selling tickets' do
      movie.expects(:find_theaters_selling_at).returns([])
      account.expects(:notify_about_tickets!).never
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
