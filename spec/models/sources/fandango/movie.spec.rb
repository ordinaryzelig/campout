require 'spec_helper'

describe Fandango::Movie do

  it '.new_from_feed instantiates new object with Fandango gem attributes' do
    stub_fandango_feed 'movies_near_me_73142.rss'
    movie_feed = Fandango.movies_near(73142).first[:movies].first
    movie = Fandango::Movie.new_from_feed(movie_feed)
    movie.title.must_equal 'Happy Feet Two'
    movie.external_id.must_equal '149198'
  end

end
