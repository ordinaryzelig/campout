ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV']

require './mailer'

require 'active_support/inflector'
require 'active_support/string_inquirer'

require 'active_record'

# Require config and lib files.
[
  './config/*.rb',
  './lib/**/*.rb',
].each do |glob_path|
  Dir[glob_path].each do |file|
    require file
  end
end

# require models.
Dir['./models/*.rb'].each { |f| require f }

# TODO: move this to config.
require './twitter'
