module RailsStyleInitialization

  def initialize(attributes)
    attributes.each do |attribute, value|
      send :"#{attribute}=", value
    end
  end

end
