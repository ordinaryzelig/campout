class Theater

  include RailsStyleInitialization

  attr_accessor :name
  attr_accessor :external_id
  attr_accessor :address
  attr_accessor :postal_code

  def short_name
    @short_name ||= name.to_theater_short_name
  end

  def ==(theater)
    return super unless theater.respond_to?(:external_id)
    return true if external_id == theater.external_id
    raise "how to compare theaters now?"
  end

end
