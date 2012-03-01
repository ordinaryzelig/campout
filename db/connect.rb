require './init'
require 'yaml'
config = YAML.load(File.open('config/database.yml').read)[ENV['RACK_ENV']]
ActiveRecord::Base.establish_connection(config)
