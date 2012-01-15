class Movie

  attr_reader :title

  def initialize(attributes)
    attributes.each do |attribute, value|
      instance_variable_set :"@#{attribute}", value
    end
  end

end
