require 'spec_helper'

describe Fandango::TheaterSource do

  it_must_behave_like_theater_source

  describe '.new_from_feed_entry' do

    before do
      stub_fandango_feed 'movies_near_me_73142.rss'
      feed_entry = Fandango.movies_near(73142).first
      @theater_source = Fandango::TheaterSource.new_from_feed_entry(feed_entry)
    end

    it 'instantiates new object with Fandango gem attributes' do
      @theater_source.name.must_equal        'Northpark 7'
      @theater_source.address.must_equal     '12100 N. May Ave Oklahoma City, OK 73120'
      @theater_source.postal_code.must_equal '73120'
      @theater_source.external_id.must_equal 'aaicu'
      @theater_source.movie_sources.size.must_equal 8
    end

    it 'instantiates movie sources' do
      movie = @theater_source.movie_sources.first
      movie.must_be_kind_of Fandango::MovieSource
    end

  end

  describe '#find_or_create!' do

    it 'finds existing theater sources from the DB' do
      existing = FactoryGirl.create(:fandango_amc)
      existing.find_or_create!
      Fandango::TheaterSource.count.must_equal 1
    end

    it 'creates theater source if it does not already exist' do
      theater = FactoryGirl.create(:amc)
      theater_source = Fandango::TheaterSource.new(external_id: 1)
      theater_source.expects(:find_or_create_theater!).returns(theater)
      theater_source = theater_source.find_or_create!
      theater_source.must_be :persisted?
      theater_source.theater.must_equal theater
    end

  end

  describe '#find_or_create_theater!' do

    it 'finds theater if movie_source already exists' do
      theater_source = FactoryGirl.build(:fandango_amc)
      Theater.count.must_equal 1
      theater = theater_source.theater
      theater_source.find_or_create_theater!.must_equal theater
      Theater.count.must_equal 1
    end

    it 'finds theater based on short name and coordinates if it exists' do
      theater = FactoryGirl.create(:amc)
      Geocoder.expects(:coordinates).with(theater.address).returns(theater.coordinates)
      theater_source = Fandango::TheaterSource.new(external_id: 1, address: theater.address, name: theater.name)
      theater_source.find_or_create_theater!.must_equal theater
    end

    it 'creates new theater if there is none at coordinates' do
      Geocoder.expects(:coordinates).returns([0, 0])
      theater_source = Fandango::TheaterSource.new(external_id: 1, name: 'amc', address: '123')
      theater = theater_source.find_or_create_theater!
      theater.must_be :persisted?
      theater.name.must_equal 'amc'
      theater.address.must_equal '123'
      theater.latitude.must_equal 0
      theater.longitude.must_equal 0
    end

  end

  it '#selling? returns true if movie_source is included in movies from Fandango gem' do
    movie_source = FactoryGirl.build(:fandango_ghost_rider)
    theater_source = Fandango::TheaterSource.new(movie_sources: [movie_source])
    theater_source.selling?(movie_source).must_equal true
  end

end
