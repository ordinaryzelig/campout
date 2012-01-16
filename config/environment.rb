module Campout

  class << self

    # E.g. Campout.env.production?
    # Default to development.
    def env
      @env ||= ActiveSupport::StringInquirer.new(ENV.fetch('RACK_ENV', 'development'))
    end

    def root_dir
      Pathname.new(__FILE__) + '../..'
    end

  end

end
