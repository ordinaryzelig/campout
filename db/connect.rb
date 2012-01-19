if Campout.env.production?
  ActiveRecord::Base.establish_connection(YAML.load('db/database.yml')[ENV['RACK_ENV']])
else
  ActiveRecord::Base.establish_connection(
    adapter:  'sqlite3',
    database: "db/#{Campout.env}.sqlite3",
  )
end
