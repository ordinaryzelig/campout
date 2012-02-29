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

    # We're really just testing the gem here.
    def diagnostics
      feeds = movies_near(73132)
      amc = feeds.detect { |feed| feed[:theater][:id] == 'aaktw' }
      raise 'AMC Quail not found' unless amc
      raise 'No movies at AMC Quail' unless amc[:movies].any?
    end

  end

end
