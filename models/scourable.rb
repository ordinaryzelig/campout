module Scourable

  def self.included(target)
    target.extend ClassMethods
  end

  module ClassMethods

    # Make request, parse, return movies.
    def scour(options)
      html = get '', query: query_options(options)
      parse html
    end

  end

end
