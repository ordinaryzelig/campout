require 'camping' # Why isn't Bundler requiring this?

Camping.goes :Campout

module Campout::Controllers
  class Index < R '/'
     def get
        render :hello
     end
  end
end

module Campout::Views
  def hello
     p  "Campout World!"
  end
end
