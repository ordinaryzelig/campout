module Fandango

  class << self

    # Use Fandango gem to find movies near zipcode.
    # Find or create theater source.
    # Return theater associations.
    # NOTE: Not optimal since we're making trips to the DB for each feed_hash, but it's simpler this way.
    def find_theaters_near(zipcode)
      movies_near(zipcode).map do |feed_hash|
        Fandango::TheaterSource.new_from_feed_entry(feed_hash).find_or_create!.theater
      end
    end

  end

end
