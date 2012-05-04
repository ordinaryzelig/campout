class Coordinates

  class << self

    # Attempt to geocode address.
    # If it fails, try less accurate info.
    # Less info is subtracting everything upto the next comma.
    def from_address(address)
      search_result = Geocoder.search(address).first
      return search_result.coordinates if search_result
      less_info = address.split(',')[1..-1]
      from_address(less_info.join.strip) unless less_info.empty?
    end

  end

end
