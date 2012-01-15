class Theater

  include RailsStyleInitialization

  attr_accessor :name
  attr_accessor :id

  class << self

    def load_from_yaml
      file = File.open("./db/sources/#{source_type.to_s.underscore}.yml")
      yaml = YAML.load(file.read)
      yaml.map { |_, atts| new(atts) }
    end

    # MovieTickets::Theater.source_type #=> MovieTickets
    # TODO: There must be a better way of doing this.
    def source_type
      Object.const_get name.split('::').first
    end

    def all
      @all ||= load_from_yaml
    end

    def first
      all.first
    end

  end

end
