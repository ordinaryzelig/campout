require 'spec_helper'

describe Fandango do

  describe '.theaters_and_movies_near' do

    before do
      stub_fandango_feed 'movies_near_me_73142.rss'
    end

    it 'returns an array of theaters with movies selling at each' do
      theaters = Fandango.theaters_near(73142)
      theaters.size.must_equal 11
      theater = theaters.first
      theater.must_be_kind_of Fandango::Theater
      theater.movies.size.must_equal 8
      theater.movies.first.must_be_kind_of Fandango::Movie
    end

  end

end
