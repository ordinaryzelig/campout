module Campout

  class << self

    # E.g. Campout.env.production?
    # Default to development.
    def env
      @env ||= ActiveSupport::StringInquirer.new(ENV['RACK_ENV'])
    end

    def root_dir
      Pathname.new(__FILE__) + '../..'
    end

  end

end
