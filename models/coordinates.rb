class Coordinates

  class << self

    # Attempt to geocode address. If it fails, try from just postal code.
    def from_address(address)
      Geocoder.coordinates(address) || Geocoder.coordinates(PostalCode.extract_from_string(address))
    end

  end

end
