module Scourable

  include RailsStyleInitialization

  def self.included(target)
    target.extend ClassMethods
  end

  module ClassMethods

    def load_from_yaml
      db_yml_file = File.open(db_yml_file_path)
      yaml = YAML.load(db_yml_file.read)
      yaml.map { |_, atts| new(atts) }
    end

    def db_yml_file_path
      Campout.root_dir + "db/sources/#{source_type.to_s.underscore}/#{type.name.underscore.pluralize}.yml"
    end

    # MovieTickets::Theater.source_type #=> MovieTickets
    # TODO: There must be a better way of doing this.
    def source_type
      Object.const_get name.split('::').first
    end

    def type
      Object.const_get name.split('::').last
    end

    def all
      @all ||= load_from_yaml
    end

    def first
      all.first
    end

  end

end
