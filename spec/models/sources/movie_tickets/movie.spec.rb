require 'spec_helper'

describe MovieTickets::Movie do

  it_must_behave_like_movie_source

  let(:movie_source) { FactoryGirl.build(:movie_tickets_ghost_rider) }

  describe '.scour' do

    it 'scrapes future titles' do
      date_test_run = Date.civil(2012, 1, 20)
      Timecop.freeze(date_test_run) do
        VCR.use_cassette('movie_tickets/movies/ghost_rider') do
          release_date = Date.civil(2012, 02, 16)
          theaters = MovieTickets::Movie.scour(
            movie_source: movie_source,
            zipcode:      10001,
          )
          theaters.size.must_equal 3
          theater = theaters.first
          theater.external_id.must_equal '10513'
        end
      end
    end

    it 'includes theaters that site is not selling tickets for' do
      date_test_run = Date.civil(2012, 1, 20)
      Timecop.freeze(date_test_run) do
        VCR.use_cassette('movie_tickets/movies/ghost_rider') do
          release_date = Date.civil(2012, 02, 16)
          theaters = MovieTickets::Movie.scour(
            movie_source: movie_source,
            zipcode:      10001,
          )
          amc_loews = '134'
          theaters.map(&:external_id).must_include amc_loews
        end
      end
    end

  end

  it '#find_theaters_selling_at uses scour to find theaters selling tickets for a movie_source' do
    MovieTickets::Movie.expects(:scour).with(movie_source: movie_source, zipcode: 10001)
    movie_source.find_theaters_selling_at(10001)
  end

end
