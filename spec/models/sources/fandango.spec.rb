require 'spec_helper'

describe Fandango do

  it_must_behave_like_ticket_source

  it '.find_theaters_near returns an array of theaters' do
    stub_fandango_feed 'movies_near_me_73142.rss'
    disable_geocoding
    # Stub so we only process 1 theater.
    feed_hash = Fandango.movies_near(73142).first
    Fandango.expects(:movies_near).returns([feed_hash])
    theaters = Fandango.find_theaters_near(73142)
    Theater.count.must_equal 1
    TheaterSource.count.must_equal 1
  end

end
