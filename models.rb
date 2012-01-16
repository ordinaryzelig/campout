# Autoload models.
[
  :Movie,
  :Scourable,
  :Theater,
].each do |const|
  autoload const, "./models/#{const.to_s.downcase}"
end

# Require sources.
Dir['./models/sources/**/*.rb'].each { |f| require f }
