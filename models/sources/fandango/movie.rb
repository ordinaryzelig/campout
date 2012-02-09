class Fandango::Movie

  include RailsStyleInitialization

  attr_accessor :title
  attr_accessor :external_id

  class << self

    # Check for tickets for unreleased movies.
    def check_for_newly_released_tickets
      unreleased.map(&:check_for_tickets).flatten
    end

    def new_from_feed(atts)
      new(
        title:       atts[:title],
        external_id: atts[:id],
      )
    end

  end

  def find_theaters_selling_at(zipcode)
    Fandango.theaters_near(zipcode).select do |theater|
      theater.selling?(self)
    end
  end

end
