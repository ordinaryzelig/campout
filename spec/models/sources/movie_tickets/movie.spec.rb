require 'spec_helper'

describe MovieTickets::Movie do

  it 'scrapes titles' do
    date = Date.new(2012, 01, 16)
    Timecop.freeze(date) do
      VCR.use_cassette('movietickets/movies/iron_lady') do
        theaters = MovieTickets::Movie.scour(
          movie: MovieTickets::Movie.first,
          date:  date,
          zipcode: 73142,
        )
        theaters.size.must_equal 3
        theaters.first.name.must_equal 'AMC Quail Springs Mall 24'
      end
    end
  end

  it '.search for pattern returns first match' do
    movie = MovieTickets::Movie.search('knight')
    movie.title.must_equal 'The Dark Knight Rises: The IMAX Experience'
  end

end
