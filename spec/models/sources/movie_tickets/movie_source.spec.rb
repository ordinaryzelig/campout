require 'spec_helper'

describe MovieTickets::MovieSource do

  it_must_behave_like_movie_source

  let(:movie_source) { FactoryGirl.build(:movie_tickets_ghost_rider) }

  describe '.scour' do

    it 'scrapes future titles' do
      date_test_run = Date.civil(2012, 1, 20)
      Timecop.freeze(date_test_run) do
        VCR.use_cassette('movie_tickets/movies/ghost_rider') do
          theaters = MovieTickets::MovieSource.scour(
            movie_source: movie_source,
            postal_code:      10001,
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
          theaters = MovieTickets::MovieSource.scour(
            movie_source: movie_source,
            postal_code:      10001,
          )
          amc_loews = '134'
          theaters.map(&:external_id).must_include amc_loews
        end
      end
    end

  end

  describe '#find_theaters_selling_at' do

    it 'uses scour to find theaters selling tickets for a movie_source' do
      MovieTickets::MovieSource.expects(:scour).with(movie_source: movie_source, postal_code: 10001).returns([])
      movie_source.find_theaters_selling_at(10001)
    end

    it 'returns theaters' do
      theater_source = FactoryGirl.create(:movie_tickets_amc)
      MovieTickets::MovieSource.expects(:scour).returns([theater_source])
      theaters = movie_source.find_theaters_selling_at(10001)
      theaters.first.must_be_kind_of Theater
    end

  end

  specify '.query_options removes spaces from postal code' do
    options = MovieTickets::MovieSource.send :query_options, postal_code: '1 2'
    options[:SearchZip].must_equal '12'
  end

end
