require 'bundler/setup'
Bundler.require :default, ENV.fetch('CAMPOUT_ENV', :development).to_sym

require 'open-uri'

require 'active_support/inflector'
require 'active_support/string_inquirer'

# Require config and lib files.
[
  './config/*.rb',
  './lib/**/*.rb',
].each do |glob_path|
  Dir[glob_path].each do |file|
    require file
  end
end

require './models'
