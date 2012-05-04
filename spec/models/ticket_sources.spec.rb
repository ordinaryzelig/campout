require 'spec_helper'

describe TicketSources do

  it '.all returns each ticket source class' do
    TicketSources.for_country('US').all.must_equal [Fandango, MovieTickets]
  end

  it '.find_theaters_near calls .find_theaters_near on each theater source' do
    postal_code = 1
    TicketSources.for_country('US').all.each { |source| source.expects(:find_theaters_near).with(postal_code, 'US') }
    TicketSources.for_country('US').find_theaters_near(postal_code)
  end

  describe '.find_theaters_selling_at' do

    let(:movie)   { FactoryGirl.build(:iron_lady, released_on: Date.current.tomorrow) }

    it 'returns an array with uniq theaters' do
      movie_sources = 2.times.map do
        source = mock
        source.expects(:find_theaters_selling_at).returns([1])
        source
      end
      movie = mock
      movie.expects(:movie_sources).returns(movie_sources)
      TicketSources.for_country('US').find_theaters_selling_at(movie, 'postal_code').must_equal [1]
    end

  end

  it '.for_country scopes to ticket sources for given country code' do
    ticket_sources = TicketSources.for_country('US').all
    ticket_sources.must_equal [Fandango, MovieTickets]
  end

  it 'supports certain countries' do
    ['US', 'CA', 'GB', 'IE'].each do |country_code|
      TicketSources.country_codes.must_include country_code
    end
  end

  it 'does not support certain countries' do
    TicketSources.support_country_code?('UK').must_equal false
  end

end
