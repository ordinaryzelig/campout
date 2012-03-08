require './init'
require 'erb'
config = YAML.load(ERB.new(File.read('config/database.yml')).result)[ENV['RACK_ENV']]
ActiveRecord::Base.establish_connection(config)
