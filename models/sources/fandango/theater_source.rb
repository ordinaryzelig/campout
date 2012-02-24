class Fandango::TheaterSource < TheaterSource

  attr_accessor :address
  attr_accessor :movie_sources
  attr_accessor :name
  attr_accessor :postal_code

  class << self

    def new_from_feed_entry(atts)
      theater_atts = atts[:theater]
      external_id = theater_atts.delete(:external_id)
      movie_sources = atts[:movies].map { |m| Fandango::MovieSource.new_from_feed_entry(m) }
      new(
        external_id:   theater_atts[:id],
        movie_sources: movie_sources,
        address:       theater_atts[:address],
        name:          theater_atts[:name],
        postal_code:   theater_atts[:postal_code],
      )
    end

    def type
      Fandango
    end

  end

  # Find existing theater source from DB if it exists.
  # Create it if it does not exist.
  def find_or_create!
    existing = self.class.find_by_external_id(external_id)
    return existing if existing
    self.class.create!(external_id: external_id, theater: find_or_create_theater!)
  end

  # Find theater using coordinates.
  # Create it if it doesn't exist.
  def find_or_create_theater!
    existing = self.theater || ::Theater.find_by_coordinates(coordinates)
    return existing if existing
    ::Theater.create! name: name, address: address, coordinates: coordinates
  end

  def coordinates
    @coordinates ||= Geocoder.coordinates(address)
  end

  def selling?(movie_source)
    movie_sources.include?(movie_source)
  end

end
