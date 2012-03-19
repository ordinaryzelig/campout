ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV']

require './mailer'

Dir['./config/*.rb'].each { |file| require file }
