require 'bundler'
Bundler.require :default, ENV.fetch('CAMPOUT_ENV', :development).to_sym

# Require models.
Dir['./models/**/*.rb'].each do |file|
  require file
end
