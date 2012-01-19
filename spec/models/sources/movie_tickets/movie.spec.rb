require 'spec_helper'

describe MovieTicketsMovie do

  it 'scrapes titles' do
    date = Date.new(2012, 01, 16)
    Timecop.freeze(date) do
      VCR.use_cassette('movietickets/movies/iron_lady') do
        movie = FactoryGirl.build(:movie_tickets_iron_lady)
        theaters = MovieTicketsMovie.scour(
          movie: movie,
          date:  date,
          zipcode: 73142,
        )
        theaters.size.must_equal 3
        theaters.first.name.must_equal 'AMC Quail Springs Mall 24'
      end
    end
  end

end
