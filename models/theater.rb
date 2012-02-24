class Theater < ActiveRecord::Base

  has_many :theater_sources

  validates :name, presence: true

  after_validation :geocode, unless: :geocoded?

  geocoded_by :address
  include HasCoordinates

  class << self

    # Use Geocoder to locate a theater.
    # coordinates should be array of lat, long.
    # Use very low radius. 0 doesn't seem to work.
    def find_by_coordinates(coordinates)
      near(coordinates, 0.000_000_001).first
    end

  end

  def short_name
    @short_name ||= name.to_theater_short_name
  end

  def geocoded?
    self.latitude.present?
  end

  # Set latitude and longitude.
  def coordinates=(coordinates)
    self.latitude, self.longitude = coordinates
  end

end
