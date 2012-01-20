namespace :db do

  desc 'Seed data'
  task :seed => :connect do
    load './db/seed.rb'
  end

  desc 'Migrate DB.'
  task :migrate => :connect do
    ActiveRecord::Migrator.migrate('db/migrations')
  end

  task :connect do
    require './init'
    require './db/connect'
  end

end

desc 'Check that parsing is working against all sources'
task :diagnostics => 'db:connect' do
  print 'movietickets.com...'
  begin
    MovieTicketsTheater.diagnostics
    puts 'OK'
    raise 'NOT!'
  rescue
    if Campout.env.production?
      Mailer.exception($!)
      puts 'failed. email sent'
    else
      puts 'error'
      raise
    end
  end
end

desc 'Check for movie on specific day in zipcode'
task :check, [:title, :date, :zipcode] => 'db:connect' do |t, args|
  title = args.title
  date = Chronic.parse(args.date).to_date
  zipcode = args.zipcode
  movie = MovieTicketsMovie.find_by_title!(title)
  theaters = movie.find_theaters_selling(date, zipcode)
  if theaters.empty?
    puts 'no go'
  else
    if Campout.env.production?
      Mailer.on_sale(movie, theaters)
      puts 'email sent'
    else
      puts theaters.map(&:name)
    end
  end
end

desc 'Run cron.rb'
task :cron => 'db:connect' do
  load Campout.root_dir + 'cron.rb'
end

# ====================================
# Testing.

require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'spec'
  t.pattern = 'spec/**/*.spec.rb'
end
