# ====================================
# DB.

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

# ====================================
# Campout.

desc 'Check that parsing is working against all sources'
task :diagnostics => 'db:connect' do
  mail_on_error do
    print 'movietickets.com...'
    movies = MovieTicketsTheater.diagnostics
    print "found #{movies.size} movies..."
    movie = movies.first
    print "checking theaters for #{movie.title}..."
    MovieTicketsMovie.diagnostics(movie)
    puts 'OK'
  end
end

desc 'Check for movie on specific day in zipcode'
task :check, [:title, :zipcode] => 'db:connect' do |t, args|
  mail_on_error do
    title = args.title
    zipcode = args.zipcode
    movie = MovieTicketsMovie.find_by_title!(title)
    theaters = movie.find_theaters_selling(zipcode)
    if theaters.empty?
      puts 'no go'
    else
      puts theaters.map(&:name)
      if Campout.env.production?
        Mailer.on_sale(movie, theaters)
        puts 'email sent'
      end
    end
  end
end

desc 'Run cron.rb'
task :cron => 'db:connect' do
  mail_on_error do
    load Campout.root_dir + 'cron.rb'
  end
end

desc 'Do some queries, get some numbers'
task :stats => 'db:connect' do
  puts "#{TwitterAccount.count} twitter accounts."
  puts "#{MovieTicketsMovieAssignment.count} movie trackers."
  puts "#{MovieTicketsMovie.count} movies."
  puts "#{MovieTicketsTheater.count} theaters."
  puts "#{MovieTicketsTheater.tracked_by_multiples.all.size} theaters tracked by multiples."
end

# ====================================
# Testing.

require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'spec'
  t.pattern = 'spec/**/*.spec.rb'
end

# ====================================
# Error handler.

def mail_on_error
  yield
rescue
  puts 'error'
  if Campout.env.production?
    Mailer.exception($!)
    puts 'email sent'
  end
  # Output exception.
  puts $!.class
  puts $!.message
  puts $!.backtrace
end
