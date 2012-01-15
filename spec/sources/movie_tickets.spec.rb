require_relative '../spec_helper'

describe MovieTickets do

  it 'scrapes titles' do
    VCR.use_cassette('movietickets/2012-01-12') do
      response = Net::HTTP.get_response(URI('http://www.movietickets.com/house_detail.asp?house_id=10834&amp;rdate=1%2F12%2F2012&amp;sortid=1'))
      movies = MovieTickets.parse(response.body)
      movies[1].title.must_equal 'The Adventures of Tintin 3D'
    end
  end

end
