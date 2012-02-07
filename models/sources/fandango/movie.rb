class Fandango::Movie

  include RailsStyleInitialization

  attr_accessor :title
  attr_accessor :external_id

  class << self

    def new_from_feed(atts)
      new(
        title:       atts[:title],
        external_id: atts[:id],
      )
    end

  end

end
