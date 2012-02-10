require 'spec_helper'

describe Fandango::Theater do

  describe '.new_from_feed' do

    before do
      stub_fandango_feed 'movies_near_me_73142.rss'
      feed_entry = Fandango.movies_near(73142).first
      @theater = Fandango::Theater.new_from_feed_entry(feed_entry)
    end

    it 'instantiates new object with Fandango gem attributes' do
      @theater.name.must_equal        'Northpark 7'
      @theater.external_id.must_equal 'aaicu'
      @theater.address.must_equal     '12100 N. May Ave Oklahoma City, OK 73120'
      @theater.postal_code.must_equal '73120'
      @theater.movies.size.must_equal 8
    end

    it 'instantiates movies' do
      movie = @theater.movies.first
      movie.must_be_kind_of Fandango::Movie
    end

  end

end
