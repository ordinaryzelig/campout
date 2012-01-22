require './init'
require './app'
run Campout

require 'rack/contrib'

use Rack::StaticCache,
  urls: ['/images'],
  root: 'assets'
