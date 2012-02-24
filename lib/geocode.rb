module Geocodable

  def geocode
    attr_accessor :latitude
    attr_accessor :longitude
    geocoded_by :address
  end

end

ActiveRecord::Base.extend(Geocoder::Model::ActiveRecord)
ActiveRecord::Base.extend Geocodable
