class Coordinates

  class << self

    # Attempt to geocode address. If it fails, try from just postal code.
    def from_address(address)
      Geocoder.coordinates(address) || Geocoder.coordinates(PostalCode.extract_from_address(address))
    end

  end

end
