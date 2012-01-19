# Not sure we need this anymore.
# Use FactoryGirl to create some stuff.
require 'factory_girl'
Dir['./spec/support/factories/*.rb'].each { |f| require f }
[
  :movie_tickets_amc,
  :movie_tickets_iron_lady,
].each do |factory|
  FactoryGirl.create(factory)
end
