require 'spec_helper'

describe Fandango::MovieSource do

  it_must_behave_like_movie_source

  it '.new_from_feed_entry instantiates new object with Fandango gem attributes' do
    stub_fandango_feed 'movies_near_me_73142.rss'
    movie_feed = Fandango.movies_near(73142).first[:movies].first
    movie_source = Fandango::MovieSource.new_from_feed_entry(movie_feed)
    movie_source.title.must_equal 'Happy Feet Two'
    movie_source.external_id.must_equal '149198'
  end

  describe '#find_theaters_selling_at' do

    it 'uses Fandango gem to get list of theaters and movies selling at each' do
      stub_fandango_feed 'movies_near_me_73142.rss'
      theater_source = FactoryGirl.create(:fandango_amc)
      theater = theater_source.theater
      movie_source = FactoryGirl.build(:fandango_ghost_rider)
      theaters = movie_source.find_theaters_selling_at(73142)
      theaters.size.must_equal 1
      theaters.first.must_equal theater
    end

  end

end
