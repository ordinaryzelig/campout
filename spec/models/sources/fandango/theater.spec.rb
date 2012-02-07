require 'spec_helper'

describe Fandango::Theater do

  describe '.new_from_feed' do

    before do
      stub_fandango_feed 'movies_near_me_73142.rss'
      feed = Fandango.movies_near(73142).first
      theater_feed = feed[:theater]
      theater_feed.merge!(movies: feed[:movies])
      @theater = Fandango::Theater.new_from_feed(theater_feed)
    end

    it 'instantiates new object with Fandango gem attributes' do
      @theater.name.must_equal 'Northpark 7'
      @theater.external_id.must_equal 'aaicu'
      @theater.movies.size.must_equal 8
    end

    it 'instantiates movies' do
      movie = @theater.movies.first
      movie.must_be_kind_of Fandango::Movie
    end

  end

end
