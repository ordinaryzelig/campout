# Autoload models.
[
  :Movie,
  :Scourable,
  :Theater,
].each do |const|
  autoload const, "./models/#{const.to_s.downcase}"
end

# Require everything else.
[
  './models/sources/**/*.rb',
  './models/social/**/*.rb',
].each do |glob|
  Dir[glob].each { |f| require f }
end
