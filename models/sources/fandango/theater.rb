class Fandango::Theater < Theater

  attr_accessor :movies

  class << self

    def new_from_feed_entry(atts)
      theater_atts = atts[:theater]
      movies = atts[:movies].map { |m| Fandango::Movie.new_from_feed(m) }
      new(
        name:        theater_atts[:name],
        external_id: theater_atts[:id],
        address:     theater_atts[:address],
        postal_code: theater_atts[:postal_code],
        movies:      movies,
      )
    end

    def type
      Fandango
    end

  end

end
