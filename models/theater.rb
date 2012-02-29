class Theater < ActiveRecord::Base

  has_many :theater_sources

  validates :name, presence: true

  after_validation :geocode, unless: :latitude

  geocoded_by :address
  include HasCoordinates

  class << self

    # Find a theater within 10 miles and same short name.
    # This is uesful because different ticket sources could have slightly different addresses and names.
    def find_by_short_name_and_coordinates(short_name, coordinates)
      near(coordinates, 10).detect do |theater|
        theater.short_name == short_name
      end
    end

  end

  def short_name
    @short_name ||= name.to_theater_short_name
  end

  # Set latitude and longitude.
  def coordinates=(coordinates)
    self.latitude, self.longitude = coordinates
  end

end
