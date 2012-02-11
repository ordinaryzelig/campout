module Fandango

  class << self

    # Use Fandango gem to find movies near zipcode, but just return instantiated Fandango::Theaters.
    def find_theaters_near(zipcode)
      movies_near(zipcode).map do |feed_hash|
        TheaterSource.new_from_feed_entry(feed_hash)
      end
    end

  end

end
