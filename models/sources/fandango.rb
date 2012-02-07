module Fandango

  class << self

    # Given zipcode, fetch list of theaters near and movies selling at each.
    # Return array of instantiated theaters.
    def theaters_near(zipcode)
      Fandango.movies_near(zipcode).map do |feed_hash|
        Theater.new_from_feed(feed_hash)
      end
    end

  end

end
