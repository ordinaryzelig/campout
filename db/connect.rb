unless Campout.env.production?
  ActiveRecord::Base.establish_connection(
    adapter:  'sqlite3',
    database: ':memory:',
  )

  ActiveRecord::Migration.verbose = false
  ActiveRecord::Migrator.migrate('db/migrations')
end
