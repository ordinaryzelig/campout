class Fandango::MovieSource < MovieSource

  attr_accessor :title

  class << self

    # Check for tickets for unreleased movies.
    def check_for_newly_released_tickets
      unreleased.map(&:check_for_tickets).flatten
    end

    def new_from_feed_entry(atts)
      new(
        title:       atts[:title],
        external_id: atts[:id],
      )
    end

  end

  # Use Fandango gem to find theaters and movies at postal_code.
  # If any theaters are selling for this movie,
  # find or create TheaterSource and return theaters,
  def find_theaters_selling_at(postal_code)
    Fandango.movies_near(postal_code).each_with_object([]) do |feed_hash, theaters_selling|
      theater_source = Fandango::TheaterSource.new_from_feed_entry(feed_hash)
      if theater_source.selling?(self)
        theater_source = theater_source.find_or_create!
        theaters_selling << theater_source.theater
      end
    end
  end

end
