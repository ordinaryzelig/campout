require 'spec_helper'

describe Fandango do

  it_must_behave_like_ticket_source

  it '.find_theaters_near returns an array of theaters with movies selling at each' do
    stub_fandango_feed 'movies_near_me_73142.rss'
    theaters = Fandango.find_theaters_near(73142)
    theaters.size.must_equal 11
    theater = theaters.first
    theater.must_be_kind_of Fandango::TheaterSource
    theater.movies.size.must_equal 8
    theater.movies.first.must_be_kind_of Fandango::MovieSource
  end

end
