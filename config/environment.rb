module Campout

  # E.g. Campout.env.production?
  # Default to development.
  def self.env
    @env ||= ActiveSupport::StringInquirer.new(ENV.fetch('RACK_ENV', 'development'))
  end

end
