class Fandango::TheaterSource < TheaterSource

  attr_accessor :movies

  class << self

    def new_from_feed_entry(atts)
      theater_atts = atts[:theater]
      external_id = theater_atts.delete(:external_id)
      movies = atts[:movies].map { |m| Fandango::MovieSource.new_from_feed(m) }
      new(
        external_id: theater_atts[:id],
        theater: ::Theater.new(theater_atts),
        movies:      movies,
      )
    end

    def type
      Fandango
    end

  end

end
