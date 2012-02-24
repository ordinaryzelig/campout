require 'spec_helper'

describe TicketSources do

  it '.all returns each ticket source class' do
    TicketSources.all.must_equal [Fandango, MovieTickets]
  end

  it '.find_theaters_near calls .find_theaters_near on each theater source' do
    zipcode = 1
    TicketSources.all.each { |source| source.expects(:find_theaters_near).with(zipcode) }
    TicketSources.find_theaters_near(zipcode)
  end

  describe '.find_theaters_selling_at' do

    let(:movie)   { FactoryGirl.build(:iron_lady, released_on: Date.tomorrow) }

    it 'returns an array with uniq theaters' do
      movie_sources = 2.times.map do
        source = mock
        source.expects(:find_theaters_selling_at).returns([1])
        source
      end
      movie = mock
      movie.expects(:movie_sources).returns(movie_sources)
      TicketSources.find_theaters_selling_at(movie, 'zipcode').must_equal [1]
    end

  end

end
