require 'spec_helper'

describe TicketsOnSaleTweet do

  it '.new composes message and truncates theater short_names' do
    theaters = 4.times.map { |i| theater = MovieTicketsTheater.new(short_name: "#{i} Very long longer longest name") }
    movie = MovieTicketsMovie.new(title: 'Significantly long longer longest name: 3D IMAX Experience')
    trackers = theaters.map { |theater| MovieTicketsTracker.new(movie_tickets_movie: movie, movie_tickets_theater: theater) }
    tweet = TicketsOnSaleTweet.new(trackers)
    tweet.valid?.must_equal true
    tweet.length.must_equal 140
    tweet.to_s.must_equal 'Significantly long longer longest.. is on sale at 0 Very long longer .., 1 Very long longer .., 2 Very long longer .., 3 Very long longer ..'
  end

  it '.new should work even when there is nothing to truncate (i.e. it is not too fancy with truncation)' do
    theater = MovieTicketsTheater.new(short_name: "AMC")
    movie = MovieTicketsMovie.new(title: 'Elf')
    tracker = MovieTicketsTracker.new(movie_tickets_movie: movie, movie_tickets_theater: theater)
    tweet = TicketsOnSaleTweet.new([tracker])
    tweet.valid?.must_equal true
    tweet.to_s.must_equal 'Elf is on sale at AMC'
  end

end
