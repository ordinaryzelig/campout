class Fandango::Theater

  include RailsStyleInitialization

  attr_accessor :name
  attr_accessor :external_id
  attr_accessor :address
  attr_accessor :movies

  class << self

    def new_from_feed(atts)
      movies = atts[:movies].map { |m| Fandango::Movie.new_from_feed(m) }
      new(
        name:        atts[:name],
        external_id: atts[:id],
        address:     atts[:zipcode],
        movies:      movies,
      )
    end

  end

end
